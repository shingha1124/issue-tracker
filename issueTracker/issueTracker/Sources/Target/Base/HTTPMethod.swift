//
//  HTTPMethod.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

enum HTTPMethod: String {
    case get, post, delete, patch
    
    var value: String {
        self.rawValue.uppercased()
    }
}
