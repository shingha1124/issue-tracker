//
//  Label.swift
//  issueTracker
//
//  Created by seongha shin on 2022/06/14.
//

import Foundation
import UIKit

struct Label: Decodable {
    let name: String
    let description: String
    @DecodedBy<HexToColor<String>> var color: UIColor
}
