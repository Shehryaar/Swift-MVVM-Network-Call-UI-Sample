//
//  GameModel.swift
//  TestCase
//
//  Created by Mac on 15/04/2021.
//

import Foundation
import UIKit

// TODO:- Please change this model according to API response

struct GameModel:Codable, CodableInit {
    var WARNING:String?
    var count :Int?
    var next :String?
    var previous :String?
    var results :[GameData]?
}

struct GameData:Codable, CodableInit {
    var name:String? = ""
    var id :Int? = 0
    var slug :String? = ""
    var released :String? = ""
    var background_image :String? = ""
    var metacritic :Int? = 0
    var genres :[GenreData]? = nil
    
    init() {
    }
    
    func genre() -> String {
        var finalGenere = ""
        if let gs = genres {
            for g in gs {
                if finalGenere.count > 0 {
                    finalGenere = "\(finalGenere), \(g.name ?? "")"
                } else {
                    finalGenere = "\(g.name ?? "")"
                }
            }
        }
        return finalGenere
    }
    
    func backgroundColor() -> UIColor {
        let userDefaults = UserDefaults.standard
        if userDefaults.isDetailOpened(id: id ?? 0) {
            return .Gray
        }
        return .tint_3
    }
}

struct GenreData:Codable, CodableInit {
    var name:String?
    var id :Int?
    var slug :String?
    var image_background :String?
    var games_count :Int?
}
