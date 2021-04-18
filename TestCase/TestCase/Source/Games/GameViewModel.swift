//
//  GameViewModel.swift
//  TestCase
//
//  Created by Shehryar on 15/04/2021.
//


import Foundation

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
    
    var updateData : (() -> ()) = {}
    
    init() {
        
//        let gamesList = [GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false),GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: true),
//                         GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false), GameModel(postImage: "https://www.shorturl.at/adrwF", postId: 1010, isMarkingAllowed: false)]
//        let games = Games(gamesList: gamesList)
//        items.append(games)
        getGames()
    }
    
    private func getGames() {
        ActivityIndicator.shared.showLoadingIndicator()
        GameRoutes.getGames(pageSize: 10, page: 1).send(GameModel.self) { (results) in
            ActivityIndicator.shared.hideLoadingIndicator()
            switch results {
            case .failure(let error):
                print("\(error.localizedDescription)")
            //self.delegate.didReceiveValidationError(message: error.localizedDescription)
            case .success(let data):
                print(data)
            }
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
    
    var gamesList: [GameModel]
    
    init(gamesList: [GameModel]) {
        self.gamesList = gamesList
        self.isEmpty = rowCount > 0
    }
}
