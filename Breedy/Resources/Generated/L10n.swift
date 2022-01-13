// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {

  public enum Action {
    /// Retry
    public static let retry = L10n.tr("Localizable", "action.retry")
  }

  public enum Alert {
    /// Cancel
    public static let cancel = L10n.tr("Localizable", "alert.cancel")
    /// OK
    public static let ok = L10n.tr("Localizable", "alert.ok")
  }

  public enum Error {
    public enum Fetch {
      /// Can't fetch the breeds from server
      public static let message = L10n.tr("Localizable", "error.fetch.message")
      /// Fetch error
      public static let title = L10n.tr("Localizable", "error.fetch.title")
    }
  }

  public enum Favorites {
    /// Favorites
    public static let title = L10n.tr("Localizable", "favorites.title")
  }

  public enum Home {
    /// Home
    public static let title = L10n.tr("Localizable", "home.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
