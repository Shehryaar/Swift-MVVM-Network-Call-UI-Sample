
//
//  MainTabBarController.swift
//  TestCase
//
//  Created by Shehryar on 13/04/2021.
//


import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var tappedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        initialSetup()
        self.tabBar.unselectedItemTintColor = UIColor.white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Actions
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = tappedIndex
        let addPost = UIStoryboard.init(name: "AddPost", bundle: nil).instantiateViewController(withIdentifier: "AddPostNavigationController")  as! UINavigationController
        addPost.modalTransitionStyle = .coverVertical
        addPost.modalPresentationStyle = .overFullScreen
        self.present(addPost, animated: true, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //Tab tapped
        guard let viewControllers = tabBarController.viewControllers else { return }
        tappedIndex = viewControllers.firstIndex(of: viewController) ?? 0
    }
    
    func initialSetup() {
        
        let gamesTableVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GamesTableViewController")
        gamesTableVC.tabBarItem.selectedImage = UIImage(named: "home.games.selected")
        gamesTableVC.tabBarItem.image = UIImage(named: "home.games")
        gamesTableVC.title =  nil
        
        let favouriteGamesTableVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavouriteGamesTableViewController")  as! UINavigationController
        favouriteGamesTableVC.tabBarItem.image = UIImage(named: "home.favouritegames")
        favouriteGamesTableVC.tabBarItem.selectedImage = UIImage(named: "home.favouritegames.selected")
        favouriteGamesTableVC.title = nil
        
        viewControllers = [gamesTableVC, favouriteGamesTableVC]
        
    }
    
}

