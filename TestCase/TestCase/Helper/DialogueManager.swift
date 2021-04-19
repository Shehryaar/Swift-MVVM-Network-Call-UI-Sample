//
//  DialogueManager.swift
//  TestCase
//
//  Created by Shehryar on 15/04/2021.
//

import Foundation
import UIKit

class DialogueManager {
    typealias methodHandler1 = () -> Void
    typealias methodHandler2 = (_ confirmed: Bool) -> Void
    
    static func showError(viewController: UIViewController, title:String, buttonTitle:String, message: String, okHandler: @escaping methodHandler1) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
            okHandler()
        }))
        viewController.present(alert, animated: true)
    }
    
    static func showConfirm(viewController: UIViewController, title: String, message: String, yesHandler: @escaping methodHandler1, noHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "no", style: .default, handler: { action in
            noHandler()
        }))
        alert.addAction(UIAlertAction(title: "yes", style: .destructive, handler: { action in
            yesHandler()
        }))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
}

public extension UIAlertController {
    func show(showOntopVC:Bool, hideAfterTenSeconds:Bool) {
        if showOntopVC {
            UIApplication.topViewController()?.present(self, animated: true)
            if hideAfterTenSeconds {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
        else {
            let win = UIWindow(frame: UIScreen.main.bounds)
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            win.rootViewController = vc
            win.windowLevel = UIWindow.Level.alert + 1  // Swift 3-4: UIWindowLevelAlert + 1
            win.makeKeyAndVisible()
            vc.present(self, animated: true, completion: nil)
            
            if hideAfterTenSeconds {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
    }
}
