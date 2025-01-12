//
//  Helpers.swift
//  ToDo
//  Created by Developer on 10/9/24.
//

import Foundation

enum Sheet: Identifiable {
    case createTodo
    case createList
    case createSection
    case editLists
    case settings
    
    var id: Self { self }
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
