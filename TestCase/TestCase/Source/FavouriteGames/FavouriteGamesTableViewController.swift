//
//  FavouriteGamesTableViewController.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import UIKit

class FavouriteGamesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchBar:UISearchBar?
    lazy var viewModel:FavouriteGamesViewModel = {
        let vm = FavouriteGamesViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        viewModel.updateData = {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavouriteGames()
    }
    
    private func initialSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(GameTableViewCell.nib, forCellReuseIdentifier: GameTableViewCell.identifier)
        self.navigationItem.title = "Favorites"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: User Actions
    @IBAction func filterAction(_ sender: UIButton) {
        // TODO:- fix transition - https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
        // let vc = FilterViewController.instantiateSearch()
        // transitionVc(vc: vc, duration: 0.5, type: .fromRight
    }
}

extension FavouriteGamesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.viewModel.createCell(tableView: tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.pushDetailScreen(indexpath: indexPath, vc: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favouriteAction = UITableViewRowAction(style: .default, title: viewModel.getSwipeTitle(indexpath: indexPath)) { [unowned self] action, indexPath in
            viewModel.swipeFavouriteAction(indexpath: indexPath, viewController: self)
        }
        return [favouriteAction]
    }
}

extension FavouriteGamesTableViewController: FavouriteGamesViewModelDelegate {
    
}
