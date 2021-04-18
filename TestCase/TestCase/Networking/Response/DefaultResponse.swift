//
//  DefaultResponse.swift
//  TestCase
//
//  Created by Shehryar on 18/04/2021.
//

import Foundation

/// Default response to check for every request since this's how this api works.
struct DefaultResponse: Codable, CodableInit {
    var status: Int
}

