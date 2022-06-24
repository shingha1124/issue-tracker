//
//  Date+Extension.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/22.
//

import Foundation

extension Date {
    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
