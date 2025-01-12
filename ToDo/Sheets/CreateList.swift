//
//  CreateTodoList.swift
//  ToDo
//  Created by Developer on 10/2/24.
//

import SwiftUI
import Introspect

struct CreateList: View {
    @Environment(Model.self) var model
    
    @State var todoListTitle = ""
    @State var color = Color.mint
    @State var icon = "list.bullet"
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Icon
                    Image(
                        systemName: model.listSelection?.icon ?? icon)
                    .fontWeight(.bold)
                    .font(.system(size: 32))
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.black)
                    .padding(16)
                    .background(Circle().foregroundStyle(model.listSelection?.color ?? color))
                    
                    // Name
                    TextField("List Title", text: Binding(
                        get: { model.listSelection?.title ?? todoListTitle },
                        set: { newValue in
                            if model.listSelection != nil {
                                model.listSelection!.title = newValue
                            } else {
                                todoListTitle = newValue
                            }
                        }
                    ))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .introspectTextField { textField in textField.becomeFirstResponder() }
                    .autocorrectionDisabled()
                    .padding(.vertical)
                    
                    // Colors
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(colorChoices, id: \.self) { color in
                                Button {
                                    self.color = color
                                    if model.listSelection != nil {
                                        model.listSelection?.color = color
                                    }
                                } label: {
                                    Circle()
                                        .frame(height: 40)
                                        .foregroundStyle(color)
                                }
                            }
                        }
                        .padding(.leading, 20)
                    }.scrollIndicators(.hidden)
                        .padding(.horizontal, -16)
                        .padding(.vertical, 12).padding(.horizontal)
                        .background(.black.opacity(0.3))
                        .cornerRadius(24)
                    
                    // Icons
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 56))]) {
                        ForEach(listIcons, id: \.self) { icon in
                            Button {
                                self.icon = icon
                                if model.listSelection != nil {
                                    model.listSelection?.icon = icon
                                }
                            } label: {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                                    .padding(12)
                                    .background(Circle().foregroundStyle(.regularMaterial))
                            }
                        }
                    }
                    .padding(.vertical, 12).padding(.horizontal)
                    .background(.black.opacity(0.3))
                    .cornerRadius(24)
                }
                .padding(.horizontal)
            }
            .toolbar {
                
                // Create
                ToolbarItem(placement: .topBarTrailing) {
                    Button(model.listSelection == nil ? "Create" : "Done") {
                        if model.listSelection == nil {
                            model.createTodoList(title: todoListTitle, color: color, icon: icon)
                        } else {
                            if let listSelection = model.listSelection,
                               let listIndex = model.todoLists.firstIndex(where: { $0.id == listSelection.id }) {
                                model.todoLists[listIndex] = listSelection
                            }
                            model.saveToUserDefaults()
                            model.listSelection = nil
                        }
                        medHaptic()
                        dismiss()
                    }
//                    .fontWeight(.medium)
                    .foregroundStyle(model.listSelection?.color ?? color)
                }
                
                // Dismiss
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .fontWeight(.heavy)
                            .padding(8)
                            .background(Circle().foregroundStyle(.regularMaterial))
                    }
                }
            }
        }
    }
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
}

#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true)) {
            CreateList()
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(40)
        }
}
