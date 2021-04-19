//
//  FavouriteGamesViewModel.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import Foundation
import UIKit

protocol FavouriteGamesViewModelDelegate {
    
}

class FavouriteGamesViewModel {
    var delegate:FavouriteGamesViewModelDelegate!
    var items = [GameViewModelItem]() {
        didSet {
            updateData()
        }
    }
    
    var updateData : (() -> ()) = {}
    
    init() {
    }
    
    func getFavouriteGames() {
        items.removeAll()
        let games = Games(gamesList: UserDefaults.standard.getFavourites())
        items.append(games)
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
    
    func getSwipeTitle(indexpath: IndexPath) -> String {
        let item = self.items[indexpath.section]
        if let gameItem = item as? Games {
            let userDefaults = UserDefaults.standard
            let game = gameItem.gamesList[indexpath.row]
            if userDefaults.isFavourite(id: game.id) {
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
            if userDefaults.isFavourite(id: game.id) {
                DialogueManager.showConfirm(viewController: viewController, title:"", message: "Are you sure you want to delete this game from favourite list?", yesHandler: {
                    userDefaults.removeFavourite(id: game.id)
                    self.getFavouriteGames()
                }){}
            } else {
                userDefaults.setFavourite(game: game)
            }
        }
    }
}
