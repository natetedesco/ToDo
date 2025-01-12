//
//  Structs.swift
//  ToDo
//  Created by Developer on 10/9/24.
//

import Foundation
import SwiftUI

struct Todo: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var date: Date
    var completed: Bool
    var note: String?
    var reminder: Date?
}

struct Section: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var todos: [Todo]
    var isExpanded = true
}

struct TodoList: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var sections: [Section]
    var note: String?
    var icon: String
    var color: Color

    enum CodingKeys: String, CodingKey {
        case id, title, sections, icon, color
    }

    init(id: UUID = UUID(), title: String, sections: [Section], icon: String, color: Color) {
        self.id = id
        self.title = title
        self.sections = sections
        self.icon = icon
        self.color = color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        sections = try container.decode([Section].self, forKey: .sections)
        icon = try container.decode(String.self, forKey: .icon)
        let colorComponents = try container.decode([CGFloat].self, forKey: .color)
        color = Color(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2])
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(sections, forKey: .sections)
        try container.encode(icon, forKey: .icon)
        let colorComponents = color.components
        try container.encode([colorComponents.red, colorComponents.green, colorComponents.blue], forKey: .color)
    }
}

// Add this extension to get color components
extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        
        return (r, g, b, o)
    }
}

