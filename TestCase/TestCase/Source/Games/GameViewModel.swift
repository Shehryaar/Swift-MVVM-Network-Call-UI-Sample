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
    private var isSearching = false
    
    private var totalGames = 0
    private var totalSearchedGames = 0
    private var searchString = ""
    
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
                    totalGames = data.count ?? 0
                    games.append(Games(gamesList: results))
                    items = games
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isDataLoading = false
                }
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
                    totalSearchedGames = data.count ?? 0
                    if self.filterPage == 1 {
                        filteredGames.removeAll()
                    }
                    filteredGames.append(Games(gamesList: results))
                    items = filteredGames
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isDataLoading = false
                }
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
    
    func fetchedGamesCount() -> Int {
        var count = 0
        for game in self.items {
            count = count + game.rowCount
        }
        return count
    }
    
    func totalGameAvailableToFetch() -> Int {
        if isSearching {
            return totalSearchedGames
        }
        return totalGames
    }
    
    func paginate(indexpath: IndexPath) {
        if indexpath.section == self.items.count - 1 { // make sure it is last section
            let item = self.items[indexpath.section]
            let count = item.rowCount
            if indexpath.row == count - 1 && !isDataLoading && fetchedGamesCount() < totalGameAvailableToFetch() {
                self.isDataLoading = true
                if isSearching {
                    self.getGames(string: searchString)
                } else {
                    self.getGames()
                }
            }
        }
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
            isSearching = true
            self.filterPage = 0
            getGames(string: string)
        } else {
            isSearching = false
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
