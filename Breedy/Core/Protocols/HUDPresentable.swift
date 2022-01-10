//
//  HUDPresentable.swift
//  Breedy
//
//  Created by Ilia Gutu on 10.01.2022.
//

import UIKit
import MBProgressHUD

protocol HUDPresentable {
    func showHUD()
    func hideHUD()
}

extension UIView: HUDPresentable {
    private func showHUDForCurrentView() {
        if let hud = MBProgressHUD.forView(self) {
            hud.show(animated: true)
        } else {
            MBProgressHUD.showAdded(to: self, animated: true)
        }
    }

    private func hideHUDForCurrentView() {
        MBProgressHUD.hide(for: self, animated: true)
    }

    func showHUD() {
        showHUDForCurrentView()
    }

    func hideHUD() {
        hideHUDForCurrentView()
    }
}

extension HUDPresentable where Self: UIViewController {
    func showHUD() {
        view.showHUD()
    }

    func hideHUD() {
        view.hideHUD()
    }
}
