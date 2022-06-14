//
//  NetworkRepository.swift
//  Starbucks
//
//  Created by seongha shin on 2022/05/10.
//

import Foundation

class NetworkRepository<Target: BaseTarget> {
    let provider = Provider<Target>()
}
