//
//  UIViewController+GenericAlert.swift
//  CookpadTask
//
//  Created by Exporent on 31.01.22.
//

import UIKit

extension ErrorReporter where Self: UIViewController {
    func showGenericAlertView() {
        let alert = UIAlertController(title: "Error",
                                      message: "Something went wrong. Please try again later by using the refresh control.",
                                      preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }
}
