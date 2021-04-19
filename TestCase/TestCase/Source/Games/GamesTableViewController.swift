//
//  GamesTableViewController.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import UIKit

class GamesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var searchBar:UISearchBar?
    lazy var viewModel:GameViewModel = {
        let vm = GameViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        //        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.75, height: 50))
        //        searchBar?.searchTextField.cornerRadius = 18
        //        searchBar?.searchTextField.borderWidth = 0.5
        //        searchBar?.searchTextField.borderColor = .tint_1
        //        searchBar?.searchTextField.font = UIFont.systemFont(ofSize: 14)
        //        searchBar?.placeholder = "What are you looking for?"
        //        let leftNavBarButton = UIBarButtonItem(customView:searchBar!)
        //        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        viewModel.updateData = {
            self.tableView.reloadData()
        }
    }
    
    func initialSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(GameTableViewCell.nib, forCellReuseIdentifier: GameTableViewCell.identifier)
        self.navigationItem.title = "Games"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: User Actions
    @IBAction func filterAction(_ sender: UIButton) {
        // TODO:- fix transition - https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/
        // let vc = FilterViewController.instantiateSearch()
        // transitionVc(vc: vc, duration: 0.5, type: .fromRight)
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
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.paginate(row: indexPath.row)
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
