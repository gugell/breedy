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
    @Published private(set) var fetchError: LookupServiceError?

    let input = Input()
    let output: Output
    private var cancellables = Set<AnyCancellable>()

    struct Dependency {
        let lookupService: LookupService

        init(lookupService: LookupService = AppEnvironment.lookupService) {
            self.lookupService = lookupService
        }
    }

    struct Input {
        fileprivate let reloadSubject = PassthroughSubject<Void, Never>()
        func viewDidLoad() { reloadSubject.send() }
    }

    struct Output {
        let showAlert: AnyPublisher<Alert, Never>
    }

    convenience init(dependency: Dependency = Dependency()) {
        self.init(dependency: dependency, scheduler: DispatchQueue.main)
    }

    init<SchedulerType: Scheduler>(dependency: Dependency = Dependency(), scheduler: SchedulerType) {
        let showAlertSubject = PassthroughSubject<Alert, Never>()
        self.output = Output(showAlert: showAlertSubject.eraseToAnyPublisher())
        fetchHomeScreenContent(showAlertSubject: showAlertSubject,
                               dependency: dependency, scheduler: scheduler)
    }

    private func fetchHomeScreenContent<SchedulerType: Scheduler>(showAlertSubject: PassthroughSubject<Alert, Never>,
                                                                  dependency: Dependency,
                                                                  scheduler: SchedulerType) {
        input.reloadSubject
            .mapTo(true)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        let items = input.reloadSubject
            .flatMapLatest {
                dependency.lookupService.lookupBreeds()
                    .forwardError(to: \.fetchError, on: self, scheduler: scheduler)
            }
            .shareReplay()
            .eraseToAnyPublisher()

        items
            .mapTo(nil)
            .assign(to: \.fetchError, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

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

        $fetchError
            .mapTo(false)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        $fetchError
            .unwrap()
            .map { error -> Alert in
                let retryAction = Alert.Action(title: L10n.Action.retry, style: .default) { [weak self] in
                    self?.input.reloadSubject.send(())
                }
                return Alert(title: L10n.Error.Fetch.title,
                             message: error.localizedDescription,
                             actions: [retryAction, Alert.Action.cancel])
            }
            .sink {
                showAlertSubject.send($0)
            }
            .store(in: &cancellables)

    }
}
