//
//  GameRoutes.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import Foundation
enum GameRoutes: URLRequestBuilder {
    case getGames(pageSize:Int, page:Int)
    
    // MARK: - Path
    internal var path: String {
        switch self {
        case .getGames:
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
            return params
        }
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .getGames:
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
