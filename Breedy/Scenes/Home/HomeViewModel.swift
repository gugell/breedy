//
//  HomeViewModel.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Combine
import UIKit

final class HomeViewModel {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, BreedCollectionViewCellViewModel>

    @Published private(set) var isLoading = false
    @Published private(set) var snapshot = Snapshot()

    let input = Input()
    private var cancellables = Set<AnyCancellable>()

    struct Dependency {
        let lookupService: LookupService

        init(lookupService: LookupService = AppEnvironment.lookupService) {
            self.lookupService = lookupService
        }
    }

    struct Input {
        fileprivate let viewDidLoadSubject = PassthroughSubject<Void, Never>()
        func viewDidLoad() { viewDidLoadSubject.send() }
    }

    convenience init(dependency: Dependency = Dependency()) {
        self.init(dependency: dependency, scheduler: DispatchQueue.main)
    }

    init<SchedulerType: Scheduler>(dependency: Dependency = Dependency(), scheduler: SchedulerType) {
        fetchHomeScreenContent(dependency: dependency, scheduler: scheduler)
    }

    private func fetchHomeScreenContent<SchedulerType: Scheduler>(dependency: Dependency, scheduler: SchedulerType) {

        input.viewDidLoadSubject
            .mapTo(true)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        let items = input.viewDidLoadSubject
            .flatMapLatest {
                dependency.lookupService.lookupBreeds()
                    .replaceError(with: [])
            }
            .shareReplay()
            .eraseToAnyPublisher()

        items.mapTo(false)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        items
            .compactMap { $0.map { BreedCollectionViewCellViewModel(name: $0.name,
                                                                    item: $0) } }
            .map { items -> Snapshot in
                var snapshot = Snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(items)
                return snapshot
            }
            .assign(to: \.snapshot, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

    }
}
