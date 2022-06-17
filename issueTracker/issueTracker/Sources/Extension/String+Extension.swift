//
//  String+Extension.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/15.
//

import Foundation
import UIKit

extension String {
    func hexToColor() -> UIColor {
        var hexString = ""
        if self.first == "#" {
            hexString = String(self.dropFirst())
        } else {
            hexString = self
        }
        
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            let b = CGFloat((hexNumber & 0x0000ff)) / 255
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        } else {
            return UIColor(red: 255, green: 0, blue: 255, alpha: 1)
        }
    }
}
