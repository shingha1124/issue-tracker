//
//  UserStore.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/17.
//

import Foundation

class TokenStore {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @UserDefault(key: UserDefault.Key.token) private var tokenData: Data?
    
    func store(_ token: Token) {
        guard let data = try? encoder.encode(token) else {
            return
        }
        self.tokenData = data
    }
    
    func getToken() -> Token? {
        guard let data = self.tokenData,
            let value = try? decoder.decode(Token.self, from: data) else {
            return nil
        }
        return value
    }
    
    func hasToken() -> Bool {
        getToken() != nil
    }
}
