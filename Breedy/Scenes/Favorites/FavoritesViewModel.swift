//
//  FavoritesViewModel.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import Combine
import UIKit

final class FavoritesViewModel {

    let input = Input()
    private var cancellables = Set<AnyCancellable>()

    typealias Snapshot = NSDiffableDataSourceSnapshot<String, BreedImageCollectionViewCellViewModel>

    @Published private(set) var isLoading = false
    @Published private(set) var snapshot = Snapshot()

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

    convenience init(dependency: Dependency = Dependency()) {
        self.init(dependency: dependency, scheduler: DispatchQueue.main)
    }

    init<SchedulerType: Scheduler>(dependency: Dependency = Dependency(), scheduler: SchedulerType) {
        fetchFavoritesContent(dependency: dependency, scheduler: scheduler)
    }

    private func fetchFavoritesContent<SchedulerType: Scheduler>(dependency: Dependency, scheduler: SchedulerType) {

        input.viewDidLoadSubject
            .mapTo(true)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        let items = input.viewDidLoadSubject
            .flatMapLatest {
                dependency.profileServices.allFavorites()
                    .replaceError(with: [])
            }
            .shareReplay()
            .eraseToAnyPublisher()

        items.mapTo(false)
            .assign(to: \.isLoading, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

        items
            .print("bookmarks")
            .map { bookmarks -> Snapshot in
                var snapshot = Snapshot()

                bookmarks.forEach { bookmark in
                    snapshot.appendSections([bookmark.breed.name])
                    let viewModels = bookmark.images
                        .map { BreedImageCollectionViewCellViewModel(url: $0, // swiftlint:disable:next line_length
                                                                     isFavorite: dependency.profileServices.isFavorite($0, breed: bookmark.breed),
                                                                     item: bookmark.breed) }
                    snapshot.appendItems(viewModels, toSection: bookmark.breed.name)
                }

                return snapshot
            }
            .assign(to: \.snapshot, on: self, ownership: .weak, scheduler: scheduler)
            .store(in: &cancellables)

    }
}
