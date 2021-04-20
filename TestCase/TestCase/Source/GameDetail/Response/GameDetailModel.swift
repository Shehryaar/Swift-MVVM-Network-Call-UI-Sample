//
//  GameDetailModel.swift
//  TestCase
//
//  Created by Shehryar on 19/04/2021.
//

import Foundation

// TODO:- Please change this model according to API response

struct GameDetailModel:Codable, CodableInit {
    var name_original:String?
    var id :Int?
    var slug :String?
    var name :String?
    var description :String?
    var metacritic :Int?
    var background_image :String?
    var background_image_additional :String?
    var website :String?
    var reddit_url :String?
    var reddit_name :String?
    var reddit_description :String?
    var description_raw :String?
    var released :String?
    var genres :[GenreData]?
}
