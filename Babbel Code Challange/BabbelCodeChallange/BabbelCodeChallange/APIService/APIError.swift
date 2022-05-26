//
//  APIError.swift
//  BabbelCodeChallange
//
//  Created by Sabade Amrut on 25/05/22.
//

import Foundation

enum APIError: Error {
    case decodingError
    case httpError(Int)
    case invalidURL
    case unknown
}
