//
//  BreedDetailViewModel.swift
//  Breedy
//
//  Created by Ilia Gutu on 11.01.2022.
//

import Combine
import UIKit

final class BreedDetailViewModel {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, BreedImageCollectionViewCellViewModel>

    @Published private(set) var isLoading = false
    @Published private(set) var snapshot = Snapshot()
    @Published private(set) var title = ""

    let input = Input()
    private var cancellables = Set<AnyCancellable>()

    struct Dependency {
        let lookupService: LookupService
        let profileServices: ProfileServices

        init(lookupService: LookupService = AppEnvironment.lookupService,
             profileServices: ProfileServices = AppEnvironment.profileServices) {
            self.lookupService = lookupService
            self.profileServices = profileServices
        }
    }

    struct Input {
        fileprivate let viewDidLoadSubject = PassthroughSubject<Void, Never>()
        func viewDidLoad() { viewDidLoadSubject.send() }
    }

    convenience init(breed: Breed, dependency: Dependency = Dependency()) {
        self.init(breed: breed, dependency: dependency, scheduler: DispatchQueue.main)
    }

    init<SchedulerType: Scheduler>(breed: Breed, dependency: Dependency = Dependency(), scheduler: SchedulerType) {
        fetchBreedContent(breed: breed, dependency: dependency, scheduler: scheduler)
    }

    private func fetchBreedContent<SchedulerType: Scheduler>(breed: Breed,
                                                             dependency: Dependency,
                                                             scheduler: SchedulerType) {

        title = breed.name.capitalized

        input.viewDidLoadSubject
            .mapTo(true)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        let items = input.viewDidLoadSubject
            .flatMapLatest {
                dependency.lookupService.lookupBreedImagesPublisher(breed.name)
                    .replaceError(with: [])
            }
            .shareReplay()
            .eraseToAnyPublisher()

        items.mapTo(false)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        items
            .compactMap { $0.map { BreedImageCollectionViewCellViewModel(url: $0,
                                                                         isFavorite: dependency.profileServices.isFavorite($0,
                                                                                                breed: breed),
                                                                         item: breed) } }
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
