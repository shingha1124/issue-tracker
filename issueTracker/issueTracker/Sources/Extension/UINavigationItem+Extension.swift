//
//  UINavigationItem+Extension.swift
//  issueTracker
//
//  Created by 이준우 on 2022/06/29.
//

import UIKit

extension UINavigationItem {
    
    func enableMutiLinedTitle() {
        setValue(true, forKey: "__largeTitleTwoLineMode")
    }
}
