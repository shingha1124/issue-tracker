//
//  APIError.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

enum APIError: Error {
    case custom(message: String, debugMessage: String)
    case objectMapping(error: Error, response: Response)
    case underlying(error: Swift.Error, response: Response?)
    case statusCode(response: Response)
    case unowned
}

extension APIError {
    var statusCode: Int {
        switch self {
        case .objectMapping(_, let response),
                .statusCode(let response):
            return response.statusCode
        case .underlying(_, let response):
            return response?.statusCode ?? -9999
        case .custom, .unowned:
            return -9999
        }
    }
}
