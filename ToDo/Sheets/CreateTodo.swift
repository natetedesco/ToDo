//
//  CreateTodo.swift
//  ToDo
//  Created by Developer on 10/2/24.
//

import SwiftUI
import Introspect

struct CreateTodo: View {
    @Environment(Model.self) var model

    @State var color: Color
    
    var body: some View {
        @Bindable var model = model
        
        NavigationStack {
            VStack {
                
                Spacer()
                
                VStack {
                    // Title
                    TextField("Todo", text: $model.todoTitle)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .focused($isFocused)
                        .introspectTextField { textField in textField.becomeFirstResponder() }
                    
                    Divider().padding(.vertical, 4)
                    
                    // Note
                    TextField("Note", text: $model.noteText, axis: .vertical)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(.black.opacity(0.3))
                .cornerRadius(24)
                .padding(.bottom)
                
                Spacer()
                
                // List Button
                HStack {
                    
                    Button {
                        model.showLists.toggle()
                    } label: {
                        HStack {
                            // List
//                            Image(systemName: model.listSelection?.icon ?? "")
//                                .font(.subheadline)
//                                .frame(width: 12, height: 12)
//                                .foregroundStyle(.white)
//                                .padding(10)
//                                .background(Circle().foregroundStyle(model.listSelection?.color ?? .teal))
                            Text(model.listSelection?.title ?? "")
                                .foregroundStyle(.white)
                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding(.leading, -4)
                                .padding(.top, 1)
                        }
                    }
                    
                    Spacer()
                    
                    // Sections
                    Menu {
                        
                        // Create Section
                        Button("New Section", systemImage: "plus") {
                            model.showCreateSection.toggle()
                            medHaptic()
                        }
                        
                        Divider()
                        
                        // Sections
                        ForEach(model.listSelection?.sections ?? []) { section in
                            Button {
                                model.sectionSelection = section
                                if !model.todoTitle.isEmpty {
                                    model.createTodo(list: model.listSelection!, section: model.sectionSelection!, name: model.todoTitle, note: model.noteText == "" ? nil : model.noteText, date: Date())
                                    
//                                    model.showCreateTodo = false
                                    
                                    model.todoTitle = ""
                                    model.noteText = ""
                                }
                                medHaptic()
                            } label: {
                                Text(section.title)
                            }
                        }
                    } label: {
                        // Section
                        Text(model.sectionSelection?.title ?? "")
                            .foregroundStyle(.white.tertiary)
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundStyle(.white.tertiary)
                            .padding(.leading, -4)
                            .padding(.top, 1)
                    }
                    
                }
                .padding(.vertical, 12).padding(.horizontal)
                .background(.black.opacity(0.3))
                .cornerRadius(24)
                .padding(.bottom)
            }
            .navigationBarTitle("New Todo", displayMode: .inline)
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.createTodo(list: model.listSelection!, section: model.sectionSelection!, name: model.todoTitle, note: model.noteText == "" ? nil : model.noteText, date: Date())
                        
//                        model.showCreateTodo = false
                        
                        model.todoTitle = ""
                        model.noteText = ""
                        medHaptic()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .font(.title3)
                    .foregroundStyle(color)
                    .fontWeight(.heavy)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                        medHaptic()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black.opacity(0.5))
                    .fontWeight(.black)
                    
                }
            }
        }
        .fullScreenCover(isPresented: $model.showLists) {
            ListSelection()
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
                .accentColor(color)
        }
    }
    
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
}



#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true)) {
            CreateTodo(color: .red)
                .presentationDetents([.fraction(3.75/10)])
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(40)
        }
}


