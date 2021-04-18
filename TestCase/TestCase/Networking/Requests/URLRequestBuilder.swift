 //
 //  URLRequestBuilder.swift
 //  TestCase
 //
 //  Created by Shehryar on 18/04/2021.
 //
 

import Foundation

protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: String { get }
    
    // MARK: - Parameters
    var parameters: Parameters? { get }
    
    var headers: HTTPHeaders { get }
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get }
}


extension URLRequestBuilder {
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var mainURL: URL  {
        return URL(string: "https://api.rawg.io/api/games")!
    }
    
    var requestURL: URL {
        //return mainURL.appendingPathComponent(path)
        let finalPath = "\(mainURL.absoluteString)\(path)"
        return URL(string: finalPath)!
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        headers.forEach { (header) in 
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        
        return request
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
