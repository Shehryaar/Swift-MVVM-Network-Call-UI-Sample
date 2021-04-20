//
//  GamesTableViewController.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import UIKit

class GamesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel:GameViewModel = {
        let vm = GameViewModel()
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
        self.tableView.reloadData()
    }
    
    private func setupSearchBar() {
        let controller = UISearchController(searchResultsController: nil)
        
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search for the games"
        definesPresentationContext = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = controller
        } else {
            navigationItem.titleView = controller.searchBar
        }
    }
    
    private func initialSetup() {
        setupSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(GameTableViewCell.nib, forCellReuseIdentifier: GameTableViewCell.identifier)
        self.navigationItem.title = "Games"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func getHintsFromSearchBar(searchBar: UISearchBar) {
        viewModel.makeSearch(string: searchBar.text ?? "")
    }
}

extension GamesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.paginate(indexpath: indexPath)
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

extension GamesTableViewController: GameViewModelDelegate {
    
}

extension GamesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //below code will cause a bit delay in search in order to give user time to type
        // this will help to reduce api call count and good user experience
        
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(GamesTableViewController.getHintsFromSearchBar),
            object: searchController.searchBar)
        self.perform(
            #selector(GamesTableViewController.getHintsFromSearchBar),
            with: searchController.searchBar,
            afterDelay: 1)
    }
}

