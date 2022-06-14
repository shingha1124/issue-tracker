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
        guard let accessToken = Container.shared.tokenStore.getToken()?.accessToken else {
            return nil
        }
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
