//
//  UserDefaults+Extension.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import Foundation

enum SaveFavouriteGameEnum : String {
    case Favourites
    case DetailOpened
}
extension UserDefaults {
    
    //MARK: Save Favourite Game
    func setFavourite(game: GameData) {
        do {
            var games = self.getFavourites()
            games.append(game)
            let data = try JSONEncoder().encode(games)
            set(data, forKey: SaveFavouriteGameEnum.Favourites.rawValue)
        } catch let error {
            print(error)
        }
    }
    
    //MARK: Retrieve Favourite Games
    func getFavourites() -> [GameData] {
        if let userData = UserDefaults.standard.value(forKey: SaveFavouriteGameEnum.Favourites.rawValue) {
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode([GameData].self, from: userData as! Data)
                return games
            } catch let error {
                print(error)
            }
        }
        return [GameData]()
    }
    
    func removeFavourite(id: Int) {
        var games = self.getFavourites()
        if let index = games.firstIndex(where: {$0.id == id}) {
            games.remove(at: index)
        }
        
        do {
            let data = try JSONEncoder().encode(games)
            set(data, forKey: SaveFavouriteGameEnum.Favourites.rawValue)
        } catch let error {
            print(error)
        }
    }
    
    func isFavourite(id: Int) -> Bool {
        let games = self.getFavourites()
        if games.firstIndex(where: {$0.id == id}) != nil {
            return true
        }
        return false
    }
    
    
    
    //MARK: Save Game id for detail open
    func saveGameWithDetailOpened(gameId: Int) {
        do {
            var games = self.getGameAlreadyOpened()
            games.append(gameId)
            let data = try JSONEncoder().encode(games)
            set(data, forKey: SaveFavouriteGameEnum.DetailOpened.rawValue)
        } catch let error {
            print(error)
        }
    }
    
    //MARK: Retrieve Favourite Games
    func getGameAlreadyOpened() -> [Int] {
        if let userData = UserDefaults.standard.value(forKey: SaveFavouriteGameEnum.DetailOpened.rawValue) {
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode([Int].self, from: userData as! Data)
                return games
            } catch let error {
                print(error)
            }
        }
        return [Int]()
    }
    
    func isDetailOpened(id: Int) -> Bool {
        let games = self.getGameAlreadyOpened()
        if games.firstIndex(where: {$0 == id}) != nil {
            return true
        }
        return false
    }
}
