//
//  DataModel.swift
//  HappySwiftUIAnimation
//
//  Created by SketchK on 2023/3/28.
//

import Foundation

struct ListSection: Codable, Identifiable {
    var id = UUID()
    var name: String
    var items: [ListItem]
    
    private enum CodingKeys : String, CodingKey { case name, items }
}
    
    
struct ListItem: Codable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var view: String
    var intro: String
    
    private enum CodingKeys : String, CodingKey { case name, intro, view }
}

