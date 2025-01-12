//
//  Functions.swift
//  ToDo
//  Created by Developer on 10/9/24.
//

import Foundation
import SwiftUI

extension Model {
    
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
