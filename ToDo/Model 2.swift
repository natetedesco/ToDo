//
//  Item.swift
//  ToDo
//  Created by Developer on 8/3/24.
//

import Foundation
import SwiftData
import SwiftUI

@Observable class Model {
    var todoLists: [TodoList]
    
    var listSelection: TodoList? { didSet { self.sectionSelection = todoLists.first?.sections.first } }
    var sectionSelection: Section?
    
    var selectedListIndex: Int?
    
    // View
    var activeSheet: Sheet?
    
    var showCreateSection = false
    var editSections = false
    var showLists = false
    
    var largeView = false
     
    var showCompleted = true

    // Create Todo
    var todoTitle: String = ""
    var noteText: String = ""
    
    init() {
        self.todoLists = generateLists()
        loadFromUserDefaults()
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
}
