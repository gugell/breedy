//
//  FavoritesViewController.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit
import VanillaConstraints

class FavoritesViewController: UIViewController, BindableType {

    var viewModel: FavoritesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Favorites.title
    }

    func bindViewModel() {

    }
}
