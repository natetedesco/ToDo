//
//  TodoLabel.swift
//  ToDo
//  Created by Developer on 10/4/24.
//

import SwiftUI

struct AddTodo: View {
    @Environment(Model.self) var model

    @FocusState var focused: Bool
    
    @State var list: TodoList
    @State var section: Section
    @State var newTodo = ""
    
    var body: some View {
        HStack {
            Image(systemName: "circle.dotted")
                .foregroundStyle(.tertiary)
                .font(.title3)
                .fontWeight(.semibold)
                .onTapGesture {
                    focused.toggle()
                    medHaptic()
                }
            TextField("", text: $newTodo)
                .focused($focused)
//                .submitLabel(.done)
                .onSubmit {
                    medHaptic()
                    model.createTodo(list: list, section: section, name: newTodo, date: Date())
                    newTodo = ""
                }
        }
    }
}


