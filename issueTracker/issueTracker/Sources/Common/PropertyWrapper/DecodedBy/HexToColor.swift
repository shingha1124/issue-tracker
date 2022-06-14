//
//  HexToColor.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import UIKit

enum HexToColor<Source: Decodable>: DecodableTransformer {
    static func transform(form decodable: Source) throws -> UIColor {
        guard let hexString = decodable as? String else {
            return .black
        }
        
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            let b = CGFloat((hexNumber & 0x0000ff)) / 255
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        } else {
            return .black
        }
    }
}
