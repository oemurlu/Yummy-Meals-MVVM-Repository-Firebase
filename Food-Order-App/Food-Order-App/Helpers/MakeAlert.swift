//
//  MakeAlert.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 26.11.2023.
//

import UIKit

struct MakeAlert {
    static func alertMessage(title: String, message: String, style: UIAlertController.Style, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        vc.present(alert, animated: true)
    }
    
    static func alertMessageWithHandler(title: String, message: String, style: UIAlertController.Style, vc: UIViewController, handler: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        vc.present(alert, animated: true)
    }
}
