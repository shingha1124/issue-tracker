//
//  BaseTarget.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

protocol BaseTarget {
    var baseURL: URL? { get }
    var path: String? { get }
    var parameter: [String: Any]? { get }
    var method: HTTPMethod { get }
    var content: HTTPContentType { get }
}

extension BaseTarget {
    var header: [String: String]? {
        var header = [String: String]()
        header["Accept"] = "application/json"
        header["Content-Type"] = content.value
        
        guard let accessToken = Container.shared.tokenStore.getToken()?.accessToken else {
            return header
        }
        header["Authorization"] = "Bearer \(accessToken)"
        return header
    }
}
