//
//  AddToList.swift
//  ToDo
//  Created by Developer on 10/12/24.
//

import SwiftUI

struct ListSelection: View {
    @Environment(Model.self) var model
    
    @State var selectedList: TodoList?
    @State var selectedColor: Color?
    
    @State var showCreateList = false
    @State var showCreateSection = false
    
    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            List {
                ForEach(model.todoLists) { list in
                    if list.sections.count > 0 {
                        
                        DisclosureGroup {
                            ForEach(list.sections) { section in
                                Button {
                                    model.listSelection = list
                                    model.sectionSelection = section
                                    model.createTodo(list: model.listSelection!, section: model.sectionSelection!, name: model.todoTitle, note: model.noteText == "" ? nil : model.noteText, date: Date())
                                    
//                                    model.showCreateTodo = false
                                    
                                    model.todoTitle = ""
                                    model.noteText = ""
                                    medHaptic()
                                } label: {
                                    HStack(alignment: .center) {
                                        Circle()
                                            .frame(width: 12)
                                            .fontWeight(.black)
                                            .foregroundStyle(list.color)
                                            .padding(.trailing, -32)
                                            .padding(.top, -4)
                                        Text(section.title)
                                            .padding(.leading)
                                    }
                                    .padding(.leading, 24)
                                }
                            }
                            
                            Button {
                                selectedList = list
                                selectedColor = list.color
                                showCreateSection.toggle()
                                medHaptic()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                    Text("New Section")
                                }
                                .padding(.leading, 23)
                            }
                            .padding(.vertical, -8)
                            .foregroundColor(list.color)
                            
                            
                        } label: {
                            HStack {
                                Image(systemName: list.icon)
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                    .frame(width: 12, height: 12)
                                    .padding(10)
                                    .background(Circle().foregroundStyle(list.color))
                                    .padding(.trailing, 4)
                                Text(list.title)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                        .accentColor(.gray)
                        
                    } else {
                        Button {
                            model.listSelection = list
                        } label: {
                            HStack {
                                
                                Image(systemName: list.icon)
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                    .frame(width: 12, height: 12)
                                    .padding(10)
                                    .background(Circle().foregroundStyle(list.color))
                                    .padding(.trailing, 4)
                                Text(list.title)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .navigationBarTitle("Add to", displayMode: .inline)
            .environment(\.defaultMinListRowHeight, 44)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showCreateList.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateList) {
            CreateList()
                .presentationBackground(.black.opacity(0.3))
                .presentationBackground(.ultraThickMaterial)
                .presentationCornerRadius(40)
        }
        .sheet(isPresented: $showCreateSection) {
            CreateSection(list: selectedList!, color: selectedColor!)
                .presentationDetents([.fraction(1/3)])
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(40)
                .accentColor(selectedColor)
        }
    }
    @Environment(\.dismiss) var dismiss
}

#Preview {
    ListSelection(selectedList: Model().todoLists[0], selectedColor: .green)
}
