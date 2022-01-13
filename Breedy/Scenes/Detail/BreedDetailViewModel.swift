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
    @Published private(set) var fetchError: LookupServiceError?
    @Published private(set) var title = ""

    let input = Input()
    let output: Output
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
        fileprivate let reloadSubject = PassthroughSubject<Void, Never>()
        func viewDidLoad() { reloadSubject.send() }
    }

    struct Output {
        let showAlert: AnyPublisher<Alert, Never>
    }

    convenience init(breed: Breed, dependency: Dependency = Dependency()) {
        self.init(breed: breed, dependency: dependency, scheduler: DispatchQueue.main)
    }

    init<SchedulerType: Scheduler>(breed: Breed, dependency: Dependency = Dependency(), scheduler: SchedulerType) {
        let showAlertSubject = PassthroughSubject<Alert, Never>()
        self.output = Output(showAlert: showAlertSubject.eraseToAnyPublisher())
        fetchBreedContent(showAlertSubject: showAlertSubject, breed: breed, dependency: dependency, scheduler: scheduler)
    }

    private func fetchBreedContent<SchedulerType: Scheduler>(showAlertSubject: PassthroughSubject<Alert, Never>, breed: Breed,
                                                             dependency: Dependency,
                                                             scheduler: SchedulerType) {

        title = breed.name.capitalized

        input.reloadSubject
            .mapTo(true)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        let items = input.reloadSubject
            .flatMapLatest {
                dependency.lookupService.lookupBreedImagesPublisher(breed.name)
                    .forwardError(to: \.fetchError, on: self, scheduler: scheduler)
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
