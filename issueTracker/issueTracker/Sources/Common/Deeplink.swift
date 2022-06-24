//
//  Deeplink.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/17.
//

import Foundation

struct Deeplink {
    let path: [DeeplinkDestination]
    let queryItems: [URLQueryItem]?
    
    init(url: URL) {
        path = Array(url.path.split(separator: "/").compactMap {
            DeeplinkDestination.init(rawValue: String($0))
        })
        queryItems = URLComponents(string: url.absoluteString)?.queryItems
    }
    
    init(path: [DeeplinkDestination], queryItems: [URLQueryItem]?) {
        self.path = path
        self.queryItems = queryItems
    }
}

enum DeeplinkDestination: String {
    case auth
    case home
    case login
}
