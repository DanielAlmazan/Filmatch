//
//  Utilities.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/12/24.
//

import Foundation
import UIKit

final class Utilities: Sendable {
  static let shared = Utilities()
  private init() {}
  
  @MainActor
  func topViewController(controller: UIViewController? = nil) -> UIViewController? {
    let controller = controller ?? UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController
    
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    
    if let tabController = controller as? UITabBarController {
      if let selectedViewController = tabController.selectedViewController {
        return topViewController(controller: selectedViewController)
      }
    }
    
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    
    return controller
  }
  
  static let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    df.locale = Locale(identifier: "en_US_POSIX")
    return df
  }()
  
  /// Parses a list of names into a human-readable string.
  /// - Parameter names: An array of names.
  /// - Returns: A formatted string of names separated by commas and "and" before the last name.
  static func parseNamesList(_ names: [String]?) -> LocalizedStringResource {
    guard let names = names, !names.isEmpty else { return "Unknown" }
    
    if names.count == 1 {
      return "\(names.first!)"
    } else {
      let allButLast = names.prefix(upTo: names.count - 1)
      
      return "\(allButLast.joined(separator: ", ")) and \(names.last!)"
    }
  }
}
