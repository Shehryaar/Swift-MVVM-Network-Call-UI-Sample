//
//  GameModel.swift
//  TestCase
//
//  Created by Mac on 15/04/2021.
//

import Foundation

// TODO:- Please change this model according to API response

struct GameModel:Codable, CodableInit {
    var WARNING:String?
    var count :Int
    var next :String?
    var previous :String?
}
