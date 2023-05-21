//
//  UIViewController+Alert.swift
//  BeWired
//
//  Created by Dmitry Kononov on 20.05.23.
//

import UIKit

extension UIViewController {
    func showErrorAlert(for message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
