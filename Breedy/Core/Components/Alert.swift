//
//  Alert.swift
//  Breedy
//
//  Created by Ilia Gutu on 13.01.2022.
//

import UIKit

struct Alert {
    let title: String?
    let message: String?
    let preferredStyle: UIAlertController.Style
    let actions: [Action]

    struct Action {
        static let cancel = Action(title: L10n.Alert.cancel, style: .cancel)
        static let ok = Action(title: L10n.Alert.ok)

        typealias Style = UIAlertAction.Style
        typealias Handler = () -> Void

        let title: String
        let style: Style
        let handler: Handler?

        init(title: String, style: Style = .default, handler: Handler? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }

    init(title: String? = nil,
         message: String? = nil,
         preferredStyle: UIAlertController.Style = .alert,
         action: Action) {
        self.init(title: title,
                  message: message,
                  preferredStyle: preferredStyle,
                  actions: [action])
    }

    init(title: String? = nil,
         message: String? = nil,
         preferredStyle: UIAlertController.Style = .alert,
         actions: [Action] = []) {
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle

        if actions.isEmpty {
            self.actions = [.ok]
        } else {
            self.actions = actions
        }
    }
}

extension UIAlertAction {
    convenience init(action: Alert.Action) {
        self.init(title: action.title,
                  style: action.style, handler: { _ in action.handler?() })
    }
}

extension UIAlertController {
    convenience init(alert: Alert) {
        self.init(title: alert.title,
                  message: alert.message,
                  preferredStyle: alert.preferredStyle)
        alert.actions
            .map(UIAlertAction.init)
            .forEach(addAction)
    }
}

extension UIViewController {
    func present(_ alert: Alert,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        present(UIAlertController(alert: alert), animated: animated, completion: completion)
    }
}
