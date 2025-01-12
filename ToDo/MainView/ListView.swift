//
//  ListView.swift
//  ToDo
//  Created by Developer on 10/4/24.
//

import SwiftUI

struct ListView: View {
    @Environment(Model.self) var model

    @State var index: Int
    
    @State var color: Color
    @Binding var globalColor: Color
    @Binding var inListView: Bool
    
    @State var isExpanded = true
    @State var editTodo = false
    
    @FocusState var focused: Bool
    
    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            List {
                
                // Sections
                ForEach($model.todoLists[index].sections) { $section in
                    DisclosureGroup(isExpanded: $section.isExpanded) {
                        ForEach($section.todos) { $todo in
                            if !todo.completed || model.showCompleted {
                                VStack {
                                    HStack {
                                        
                                        // Circle
                                        ZStack {
                                            if todo.completed {
                                                Image(systemName: "circle.inset.filled")
                                                    .foregroundStyle(color)
                                                    .font(.title3)
                                            } else {
                                                Image(systemName: "circle")
                                                    .foregroundStyle(.white.tertiary)
                                                    .font(.title3)
                                            }
                                        }
                                        .onTapGesture {
                                            medHaptic()
                                            model.completeTodo(todo: todo)
                                        }
                                        
                                        // Todo
                                        TextField("", text: $todo.name, axis: .vertical)
                                            .focused($focused)
                                    }
                                    
                                    // Note
                                    if todo.note != nil {
                                        Text(todo.note ?? "")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 32)
                                            .padding(.top, -4)
                                    }
                                }
                                .accentColor(color)
                                .padding(.vertical, 8)
                                .listRowSeparator(.hidden)
                                .alignmentGuide(.listRowSeparatorLeading) { _ in 32 }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: -4, bottom: 0, trailing: 0))
                            }
                        }
                        .onMove { source, destination in
                            move(from: source, to: destination, in: section)
                        }
                        .onDelete { source in
                            deleteTodo(at: source, section: section)
                        }
                        
                        AddTodo(list: model.todoLists[index], section: section)
                            .listRowInsets(EdgeInsets(top: 0, leading: -4, bottom: 0, trailing: 0))
                            .accentColor(color)
                        
                    } label: {
                        HStack {
                            Text(section.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                            
//                            Image(systemName: "chevron.down")
//                                .font(.caption2)
//                                .fontWeight(.bold)
//                                .foregroundStyle(color)
//                                .padding(.top, 2)
//                                .rotationEffect(Angle(degrees: section.isExpanded ? 0 : -90))
//                                .animation(.default, value: section.isExpanded)
                        }
                        .padding(.bottom, -16)
                    }
                    .accentColor(.clear) // hide disclosure arrow
                    .frame(maxWidth: .infinity)
                }
                .onDelete(perform: deleteSection)
                .onMove(perform: moveSection)
                .animation(.default, value: model.todoLists)
                .animation(.default, value: model.showCompleted)
                .listRowSeparator(.hidden)
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focused = false
                            model.saveToUserDefaults()
                            medHaptic()
                        }
                    }
                }
            }
            .onAppear {
                model.listSelection = model.todoLists[index]
                if !model.todoLists[index].sections.isEmpty {
                    model.sectionSelection = model.listSelection?.sections[0]
                } else {
                    model.sectionSelection = nil
                }
                globalColor = color
                inListView = true
            }
            .onDisappear {
                model.listSelection = nil
                globalColor = .mint
                inListView = false
            }
        }
        .sheet(isPresented: $model.showCreateSection) {
            CreateSection(list: model.todoLists[index], color: color)
                .presentationDetents([.fraction(1/3)])
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(40)
                .accentColor(color)
        }
        
        .sheet(isPresented: $model.editSections) {
            EditSections(index: index)
                .presentationDetents([.large, .medium])
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(40)
                .presentationDragIndicator(.hidden)
                .accentColor(color)
        }
        .sheet(isPresented: $editTodo) {
            
        }
    }
    
    func moveSection(from source: IndexSet, to destination: Int) {
        model.todoLists[index].sections.move(fromOffsets: source, toOffset: destination)
        model.saveToUserDefaults()
    }
    func deleteSection(at offsets: IndexSet) {
            model.todoLists[index].sections.remove(atOffsets: offsets)
            model.saveToUserDefaults()
    }
    
    func move(from source: IndexSet, to destination: Int, in section: Section) {
        if let sectionIndex = model.todoLists[index].sections.firstIndex(where: { $0.id == section.id }) {
            model.todoLists[index].sections[sectionIndex].todos.move(fromOffsets: source, toOffset: destination)
            model.saveToUserDefaults()
        }
    }
    
    func deleteTodo(at offsets: IndexSet, section: Section) {
        if let sectionIndex = model.todoLists[index].sections.firstIndex(where: { $0.id == section.id }) {
            model.todoLists[index].sections[sectionIndex].todos.remove(atOffsets: offsets)
            model.saveToUserDefaults()
        }
    }
    
    func doSubmit() {
        model.saveToUserDefaults()
    }
    
}

extension View {
    func onEnter(@Binding of text: String, action: @escaping () -> ()) -> some View {
        onChange(of: text) { newValue in
            if let last = newValue.last, last == "\n" {
                text.removeLast()
                // do your submit logic here?
                action()
            }
        }
    }
}

#Preview {
    NavigationView {
        VStack {
            ListView(index: 0,
                     color: .red,
                     globalColor: .constant(.red),
                     inListView: .constant(true))
        }
        .navigationTitle("List")
    }
}

