//
//  GameDetailViewModel.swift
//  TestCase
//
//  Created by Shehryar on 19/04/2021.
//

import Foundation
import UIKit

protocol GameDetailViewModelDelegate {
    func didGameStatusUpdated()
}

class GameDetailViewModel {
    var delegate:GameDetailViewModelDelegate!
    var item : GameDetailModel? {
        didSet {
            updateData()
        }
    }
    
    var updateData : (() -> ()) = {}
    
    init() {
    }
    
    func getGameDetail(id:Int) {
        saveGameId(id: id)
        
        ActivityIndicator.shared.showLoadingIndicator()
        GameRoutes.getGameDetail(id: id).send(GameDetailModel.self) { [unowned self] (results) in
            ActivityIndicator.shared.hideLoadingIndicator()
            switch results {
            case .failure(let error):
                print("\(error.localizedDescription)")
            case .success(let data):
                self.item = data
            }
        }
    }
    
    func saveGameId(id:Int) {
        UserDefaults.standard.saveGameWithDetailOpened(gameId: id)
    }
    
    func setImage(imageView:UIImageView) {
        let url = URL(string: item?.background_image ?? "google.com")!
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage.init(named: "noImage"),
            options: [
                .cacheOriginalImage,
                .transition(.fade(0.25))
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { result in
                // Done
            }
        )
    }
    
    func redditAction() {
        open(url: item?.reddit_url ?? "google.com")
    }
    
    func websiteAction() {
        open(url: item?.website ?? "google.com")
    }
    
    private func open(url: String) {
        if let URL = URL(string: url),
           UIApplication.shared.canOpenURL(URL) {
            UIApplication.shared.open(URL, options: [:]) { (opened) in
                if(opened) {
                    print("URL Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
    
    func getButtonTitle() -> String {
        let userDefaults = UserDefaults.standard
        if userDefaults.isFavourite(id: item?.id ?? 0) {
            return "Unfavourite"
        } else {
            return "Favourite"
        }
    }
    
    func navigationButtonAction(viewController:UIViewController) {
        let userDefaults = UserDefaults.standard
        if userDefaults.isFavourite(id: item?.id ?? 0) {
            DialogueManager.showConfirm(viewController: viewController, title:"", message: "Are you sure you want to delete this game from favourite list?", yesHandler: { [unowned self] in
                userDefaults.removeFavourite(id: item?.id ?? 0)
                if let del = self.delegate {
                    del.didGameStatusUpdated()
                }
            }){}
        } else {
            userDefaults.setFavourite(game: game())
            if let del = self.delegate {
                del.didGameStatusUpdated()
            }
        }
    }
    
    private func game() -> GameData {
        var game = GameData()
        game.name = item?.name
        game.id = item?.id ?? 0
        game.slug = item?.slug
        game.released = item?.released
        game.background_image = item?.background_image
        game.metacritic = item?.metacritic ?? 0
        game.genres = item?.genres
        return game
    }
}
