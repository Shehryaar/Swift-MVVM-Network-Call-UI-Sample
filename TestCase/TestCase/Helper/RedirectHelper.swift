//
//  RedirectHelper.swift
//  TestCase
//
//  Created by Shehryar on 15/04/2021.
//

import UIKit

final class RedirectHelper {
    
    enum Stoyboard : String {
        case Main
    }
    
    private var window : UIWindow!
    
    init(window: UIWindow?) {
        if window != nil {
            self.window = window
        } else {
            guard let temp : UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return}
            self.window = temp
        }
    }
    
    func determineRoutes (storyBoard: Stoyboard? = nil) {

        let transition = CATransition()
        transition.type = .reveal
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: self.window.bounds.height))
        myView.backgroundColor = .white
        window.addSubview(myView)
        
        self.setRootToMain(transition: transition)
    }
    
    func setRootToMain(transition :CATransition) {
        let MainTabbar = MainTabBarController()
        window.set(rootViewController: MainTabbar, withTransition: transition)
        window.makeKeyAndVisible()
    }
}

extension UIWindow {
    
    static var topWindow: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.normal
        window.makeKeyAndVisible()
        
        return window
    }
    
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        /// In iOS 13 we don't want to remove the transition view as it'll create a blank screen
        /// TODO: fix leak on iOS 13
        if #available(iOS 13.0, *) {} else {
            if let transitionViewClass = NSClassFromString("UITransitionView") {
                for subview in subviews where subview.isKind(of: transitionViewClass) {
                    subview.removeFromSuperview()
                }
            }
        }
        
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
extension UIViewController{
    //MARK:- Navigation transparent
    func transparentNavigation() {
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
    }
    
    func backButtonRemoveText() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .tint_1
    }
}


