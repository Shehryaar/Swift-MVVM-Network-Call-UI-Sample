//
//  GameRoutes.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import Foundation
enum GameRoutes: URLRequestBuilder {
    case getGames(pageSize:Int, page:Int)
    case getGameDetail(id:Int)
    case searchGames(pageSize:Int, page:Int, string:String)
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .getGames:
            return ""
        case .getGameDetail:
            return "/\(parameters?["id"] ?? "")"
        case .searchGames:
            return ""
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters.init()
        switch self {
        
        case .getGames(let pageSize, let page):
            params["page_size"] =  pageSize
            params["page"] =  page
            params["key"] =  "a20ae2bb297c40a481e7557e42b19a88"
            return params
        case .getGameDetail(let id):
            params["id"] =  id
            params["key"] =  "a20ae2bb297c40a481e7557e42b19a88"
            return params
        case .searchGames(let pageSize, let page, let string):
            params["page_size"] =  pageSize
            params["page"] =  page
            params["search"] =  string
            params["key"] =  "a20ae2bb297c40a481e7557e42b19a88"
            return params
        }
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .getGames:
            return .get
        case .getGameDetail:
            return .get
        case .searchGames:
            return .get
        }
    }
    
    // MARK: - HTTPHeaders
    internal var headers: HTTPHeaders {
        let header:HTTPHeaders =
            [ "Accept": "application/json" //  add token here if needed
            ]
        
        switch self {
        default:
            return header
        }
    }
}
