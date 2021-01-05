//
//  File.swift
//  Notes
//
//  Created by A friend on 1/1/21.
//  Copyright © 2021 Balaji. All rights reserved.
//

import Foundation

struct Note : Identifiable, Codable {
    var id : String
    var title : String
    var folders : [String]
    var content : String
    var date : String
}
