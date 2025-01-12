//
//  Item.swift
//  ToDo
//
//  Created by Developer on 8/3/24.
//

import Foundation
import SwiftData
import SwiftUI

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

struct Section: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var todos: [Todo]
}

struct Todo: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var date: Date
    var completed: Bool
    var note: String?
    var reminder: Date?
}

@Observable class Model {
    var todoLists: [TodoList]
    
    var listSelection: TodoList? { didSet { self.sectionSelection = todoLists.first?.sections.first } }
    var sectionSelection: Section?
    
    var showCreateList = false
    var showCreateSection = false
    var showCreateTodo = false
    var showSettings = false
    
    var editSections = false
    
    var editLists = false
    
    var showCompleted = true

    var placeTodo = false
    
    init() {
        self.todoLists = generateLists()
        loadFromUserDefaults()
        setSelected()
    }
    
    func setSelected() {
        self.listSelection = todoLists.first
        self.sectionSelection = todoLists.first?.sections.first
    }
    
    // Save to UserDefaults
    func saveToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(todoLists)
            UserDefaults.standard.set(encodedData, forKey: "todoLists")
        } catch {
            print("Error saving to UserDefaults: \(error)")
        }
    }
    
    // Load from UserDefaults
    func loadFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "todoLists") {
            do {
                let decoder = JSONDecoder()
                todoLists = try decoder.decode([TodoList].self, from: savedData)
            } catch {
                print("Error loading from UserDefaults: \(error)")
            }
        }
    }
    
    // Create TodoList
    func createTodoList(title: String, color: Color, icon: String) {
        let newTodoList = TodoList(title: title, sections: [], icon: icon, color: color)
        todoLists.append(newTodoList)
        saveToUserDefaults()
    }
    
    // Delete TodoList
    func deleteTodoList(listId: UUID) {
        todoLists.removeAll { $0.id == listId }
        saveToUserDefaults()
    }
    
    // Create Section
    func createSection(list: TodoList, title: String) {
        if let index = todoLists.firstIndex(where: { $0.id == list.id }) {
            let newSection = Section(title: title, todos: [])
            todoLists[index].sections.append(newSection)
            saveToUserDefaults()
        }
    }
    
    // Delete Section
    func deleteSection(listId: UUID, sectionId: UUID) {
        if let listIndex = todoLists.firstIndex(where: { $0.id == listId }) {
            todoLists[listIndex].sections.removeAll { $0.id == sectionId }
            saveToUserDefaults()
        }
    }
    
    // Create Todo
    func createTodo(list: TodoList, section: Section, name: String, note: String? = nil, date: Date) {
        if let listIndex = todoLists.firstIndex(where: { $0.id == list.id }),
           let sectionIndex = todoLists[listIndex].sections.firstIndex(where: { $0.id == section.id }) {
            let newTodo = Todo(name: name, date: date, completed: false, note: note)
            todoLists[listIndex].sections[sectionIndex].todos.append(newTodo)
            saveToUserDefaults()
        }
    }
    
    // Delete Todo
    func deleteTodo(todo: Todo) {
        for listIndex in 0..<todoLists.count {
            for sectionIndex in 0..<todoLists[listIndex].sections.count {
                if let todoIndex = todoLists[listIndex].sections[sectionIndex].todos.firstIndex(where: { $0.id == todo.id }) {
                    todoLists[listIndex].sections[sectionIndex].todos.remove(at: todoIndex)
                    saveToUserDefaults()
                }
            }
        }
    }
    
    func completeTodo(todo: Todo) {
        for listIndex in 0..<todoLists.count {
            for sectionIndex in 0..<todoLists[listIndex].sections.count {
                if let todoIndex = todoLists[listIndex].sections[sectionIndex].todos.firstIndex(where: { $0.id == todo.id }) {
                    todoLists[listIndex].sections[sectionIndex].todos[todoIndex].completed.toggle()
                    saveToUserDefaults()
                    return // Exit the function after completing the todo
                }
            }
        }
    }
}

func generateLists() -> [TodoList] {
    return [
        TodoList(title: "Life", sections: [
            Section(title: "Groceries", todos: [
                Todo(name: "Buy milk", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Get fresh vegetables", date: Date().addingTimeInterval(172800), completed: false)
            ]),
            Section(title: "Finance", todos: [
                Todo(name: "Pay electricity bill", date: Date().addingTimeInterval(604800), completed: false),
                Todo(name: "Review monthly budget", date: Date().addingTimeInterval(259200), completed: false)
            ]),
            Section(title: "Home", todos: [
                Todo(name: "Clean garage", date: Date().addingTimeInterval(518400), completed: false),
                Todo(name: "Fix leaky faucet", date: Date().addingTimeInterval(345600), completed: false)
            ])
        ], icon: "list.bullet", color: .red),
        TodoList(title: "Work", sections: [
            Section(title: "Outreach", todos: [
                Todo(name: "Email potential clients", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Prepare pitch deck", date: Date().addingTimeInterval(259200), completed: false)
            ]),
            Section(title: "Meetings", todos: [
                Todo(name: "Team standup at 10 AM", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Client presentation at 2 PM", date: Date().addingTimeInterval(172800), completed: false)
            ])
        ], icon: "briefcase.fill", color: .yellow),
        TodoList(title: "Fun", sections: [
            Section(title: "Hobbies", todos: [
                Todo(name: "Practice guitar for 30 minutes", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Read a chapter of new novel", date: Date().addingTimeInterval(172800), completed: false)
            ]),
            Section(title: "Social", todos: [
                Todo(name: "Plan weekend barbecue", date: Date().addingTimeInterval(345600), completed: false),
                Todo(name: "Call mom", date: Date().addingTimeInterval(259200), completed: false)
            ])
        ], icon: "figure.run", color: .orange),
        TodoList(title: "Tech", sections: [
            Section(title: "Development", todos: [
                Todo(name: "Debug login feature", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Implement dark mode", date: Date().addingTimeInterval(259200), completed: false)
            ]),
            Section(title: "Marketing", todos: [
                Todo(name: "Create App Store screenshots", date: Date().addingTimeInterval(345600), completed: false),
                Todo(name: "Write app description", date: Date().addingTimeInterval(172800), completed: false)
            ])
        ], icon: "desktopcomputer", color: .teal),
        TodoList(title: "Flow Notes", sections: [
            Section(title: "Design", todos: [
                Todo(name: "Sketch new UI for dashboard", date: Date().addingTimeInterval(172800), completed: false),
                Todo(name: "Create color palette", date: Date().addingTimeInterval(259200), completed: false)
            ]),
            Section(title: "Bugs", todos: [
                Todo(name: "Fix crash on startup", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Address memory leak in profile view", date: Date().addingTimeInterval(172800), completed: false)
            ]),
            Section(title: "Ideas", todos: [
                Todo(name: "Brainstorm new features for v2.0", date: Date().addingTimeInterval(518400), completed: false),
                Todo(name: "Research AI integration possibilities", date: Date().addingTimeInterval(604800), completed: false)
            ])
        ], icon: "note.text", color: .cyan),
        TodoList(title: "News App", sections: [
            Section(title: "Design", todos: [
                Todo(name: "Create wireframes for article view", date: Date().addingTimeInterval(259200), completed: false),
                Todo(name: "Design app icon", date: Date().addingTimeInterval(345600), completed: false)
            ]),
            Section(title: "Bugs", todos: [
                Todo(name: "Fix image loading issue", date: Date().addingTimeInterval(86400), completed: false),
                Todo(name: "Address push notification delay", date: Date().addingTimeInterval(172800), completed: false)
            ]),
            Section(title: "Ideas", todos: [
                Todo(name: "Explore personalized news feed algorithm", date: Date().addingTimeInterval(518400), completed: false),
                Todo(name: "Consider adding a 'save for later' feature", date: Date().addingTimeInterval(604800), completed: false)
            ])
        ], icon: "newspaper.fill", color: .mint),
        TodoList(title: "Explore", sections: [
            Section(title: "Features", todos: [
                Todo(name: "Implement map integration", date: Date().addingTimeInterval(259200), completed: false),
                Todo(name: "Add wildlife database", date: Date().addingTimeInterval(345600), completed: false)
            ]),
            Section(title: "Content", todos: [
                Todo(name: "Write articles on local flora", date: Date().addingTimeInterval(432000), completed: false),
                Todo(name: "Create guide for bird watching", date: Date().addingTimeInterval(518400), completed: false)
            ])
        ], icon: "leaf.fill", color: .green),
        TodoList(title: "Sunrise Alarm", sections: [
            Section(title: "Development", todos: [
                Todo(name: "Implement gradual brightness increase", date: Date().addingTimeInterval(259200), completed: false),
                Todo(name: "Add customizable alarm sounds", date: Date().addingTimeInterval(345600), completed: false)
            ]),
            Section(title: "Testing", todos: [
                Todo(name: "Test alarm reliability", date: Date().addingTimeInterval(432000), completed: false),
                Todo(name: "Conduct user experience survey", date: Date().addingTimeInterval(518400), completed: false)
            ])
        ], icon: "sun.max.fill", color: .yellow)
    ]
}

let listIcons = [
    "list.bullet",
    "briefcase.fill",
    "figure.run",
    "desktopcomputer",
    "note.text",
    "newspaper.fill",
    "leaf.fill",
    "sun.max.fill",
    "house.fill",
    "cart.fill",
    "dollarsign.circle.fill",
    "wrench.fill",
    "book.fill",
    "music.note",
    "airplane",
    "car.fill",
    "gift.fill",
    "heart.fill",
    "star.fill",
    "flag.fill",
    "camera.fill",
    "paintbrush.fill",
    "graduationcap.fill",
    "gamecontroller.fill",
    "bag.fill",
    "alarm.fill",
    "bolt.fill",
    "cloud.fill",
    "moon.fill",
    "flame.fill"
]

let colorChoices: [Color] = [
    .red,
    .orange,
    .yellow,
    .green,
    .mint,
    .teal,
    .cyan,
    .blue,
    .indigo,
    .purple,
    .pink,
    .brown,
    .gray
]
