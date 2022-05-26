//
//  ViewController+Alert.swift
//  BabbelCodeChallange
//
//  Created by Sabade Amrut on 26/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String, actions: [UIAlertAction], identifier: String? =  nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = identifier

        actions.forEach { action in
            alertController.addAction(action)
        }

        self.present(alertController, animated: true)
    }

}
