//
//  EditSections.swift
//  ToDo
//  Created by Developer on 10/6/24.
//

import SwiftUI

struct EditSections: View {
    @Environment(Model.self) var model

    @State var index: Int
        
    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            List {
                ForEach($model.todoLists[index].sections) { $section in
                    TextField("", text: $section.title)
                        .submitLabel(.done)
                        .onSubmit {
                            model.saveToUserDefaults()
                        }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .padding(.top, -16)
            
            .navigationBarTitle("Edit Sections", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Add") {
                        model.createSection(list: model.todoLists[index], title: "")
                    }
                }
            }
            .environment(\.editMode, .constant(.active))  // This line makes it always editable
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.todoLists[index].sections.move(fromOffsets: source, toOffset: destination)
        model.saveToUserDefaults()
    }
    
    func delete(at offsets: IndexSet) {
        model.todoLists[index].sections.remove(atOffsets: offsets)
        model.saveToUserDefaults()
    }
    @Environment(\.dismiss) var dismiss
}

struct EditLists: View {
    @Environment(Model.self) var model
    
    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            List {
                ForEach($model.todoLists) { $list in
                    TextField("", text: $list.title)
                        .submitLabel(.done)
                        .onSubmit {
                            model.saveToUserDefaults()
                        }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .padding(.top, -16)
            .navigationBarTitle("Edit Lists", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .environment(\.editMode, .constant(.active))  // This line makes it always editable
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.todoLists.move(fromOffsets: source, toOffset: destination)
        model.saveToUserDefaults()
    }
    
    func delete(at offsets: IndexSet) {
        model.todoLists.remove(atOffsets: offsets)
        model.saveToUserDefaults()
    }
    
    @Environment(\.dismiss) var dismiss
}

#Preview {
    EditSections(index: 0)
}

#Preview {
    EditLists()
        .environment(Model())
}
