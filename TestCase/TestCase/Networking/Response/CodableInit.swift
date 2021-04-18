//
//  CodableInit.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//


import Foundation

protocol CodableInit: Codable {
    init(data: Data) throws
}

extension CodableInit  {
    init(data: Data) throws {
        let decoder = JSONDecoder()

        self = try decoder.decode(Self.self, from: data)
    }
}


