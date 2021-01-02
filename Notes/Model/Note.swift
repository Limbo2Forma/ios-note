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
    var ownerId: String
    var title : String
    var location: String
    var content: String
    var date : String
    
    init()
}
