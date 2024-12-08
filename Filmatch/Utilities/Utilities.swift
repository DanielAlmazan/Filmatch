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
}
