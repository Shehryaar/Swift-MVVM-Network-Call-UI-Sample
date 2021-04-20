//
//  GameViewModel.swift
//  TestCase
//
//  Created by Shehryar on 15/04/2021.
//


import Foundation
import UIKit

enum GameViewModelItemType {
    case game
}

protocol GameViewModelItem {
    var type: GameViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

protocol GameViewModelDelegate {
    
}

class GameViewModel {
    var delegate:GameViewModelDelegate!
    var items = [GameViewModelItem]() {
        didSet {
            updateData()
        }
    }
    
    private var games = [GameViewModelItem]()
    private var filteredGames = [GameViewModelItem]()
    
    var updateData : (() -> ()) = {}
    private var filterPage = 0
    private var page = 0
    private let pageSize = 10
    private var isDataLoading = false
    
    init() {
        self.getGames()
    }
    
    private func getGames() {
        self.page = self.page + 1
        self.isDataLoading = true
        ActivityIndicator.shared.showLoadingIndicator()
        GameRoutes.getGames(pageSize: pageSize, page: page).send(GameModel.self) { [unowned self] (results) in
            ActivityIndicator.shared.hideLoadingIndicator()
            switch results {
            case .failure(let error):
                print("\(error)")
                self.isDataLoading = false
            case .success(let data):
                if let results = data.results {
                    games.append(Games(gamesList: results))
                    items = games
                }
                self.isDataLoading = false
            }
        }
    }
    
    private func getGames(string: String) {
        self.filterPage = self.filterPage + 1
        self.isDataLoading = true
        GameRoutes.searchGames(pageSize: pageSize, page: filterPage, string: string).send(GameModel.self) { [unowned self] (results) in
            switch results {
            case .failure(let error):
                print("\(error)")
                self.isDataLoading = false
            case .success(let data):
                if let results = data.results {
                    if self.filterPage == 1 {
                        filteredGames.removeAll()
                    }
                    filteredGames.append(Games(gamesList: results))
                    items = filteredGames
                }
                self.isDataLoading = false
            }
        }
    }
    
    func createCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.section]
        switch item.type {
        case .game:
            if let gameItem = item as? Games, let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell {
                cell.gameData = gameItem.gamesList[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func paginate(row: Int) {
        let count = items.count
        if row == items.count - 1 && !isDataLoading && count < 100 /*&& !self.isFirstLoad*/ {
            //self.getGames()
        }
        //self.isFirstLoad = false
    }
    
    func getSwipeTitle(indexpath: IndexPath) -> String {
        let item = self.items[indexpath.section]
        if let gameItem = item as? Games {
            let userDefaults = UserDefaults.standard
            let game = gameItem.gamesList[indexpath.row]
            if userDefaults.isFavourite(id: game.id ?? 0) {
                return "Delete favourite"
            } else {
                return "Mark favourite"
            }
        }
        return "Mark favourite"
    }
    
    func swipeFavouriteAction(indexpath: IndexPath, viewController:UIViewController) {
        let item = self.items[indexpath.section]
        if let gameItem = item as? Games {
            let userDefaults = UserDefaults.standard
            let game = gameItem.gamesList[indexpath.row]
            if userDefaults.isFavourite(id: game.id ?? 0) {
                DialogueManager.showConfirm(viewController: viewController, title:"", message: "Are you sure you want to delete this game from favourite list?", yesHandler: {
                    userDefaults.removeFavourite(id: game.id ?? 0)
                }){}
            } else {
                userDefaults.setFavourite(game: game)
            }
        }
    }
    
    func pushDetailScreen(indexpath:IndexPath, vc:GamesTableViewController) {
        let gameDetailvVC = GameDetailViewController.instantiateMain()
        let item = items[indexpath.section]
        switch item.type {
        case .game:
            if let gameItem = item as? Games {
                gameDetailvVC.gameId = gameItem.gamesList[indexpath.row].id ?? 0
            }
        }
        vc.navigationController?.pushViewController(gameDetailvVC, animated: true)
    }
    
    func makeSearch(string: String) {
        if string.count > 2 {
            self.filterPage = 0
            getGames(string: string)
        } else {
            items = games
        }
    }
}

//MARK:- Posts
class Games: GameViewModelItem {
    var type: GameViewModelItemType {
        return .game
    }
    
    var sectionTitle: String {
        return "Games"
    }
    
    var rowCount: Int {
        return gamesList.count
    }
    
    var isEmpty = false
    
    var gamesList: [GameData]
    
    init(gamesList: [GameData]) {
        self.gamesList = gamesList
        self.isEmpty = rowCount > 0
    }
}
