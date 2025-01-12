//
//  ContentView.swift
//  ToDo
//  Created by Developer on 8/3/24.
//

import SwiftUI
import SwiftData
import Introspect

struct ContentView: View {
    @Environment(Model.self) var model
    
    @State var newNote = ""
    @State var selectedColor = Color.mint
    @State var inListView = false
    
    var body: some View {
        @Bindable var model = model
        ZStack {
            NavigationStack {
                VStack {
                    
                    if model.largeView {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {
                                
                                // Lists
                                ForEach(model.todoLists, id: \.id) { list in
                                    
                                    NavigationLink {
                                        ListView(index: model.todoLists.firstIndex(where: { $0.id == list.id }) ?? 0,
                                                 color: list.color,
                                                 globalColor: $selectedColor,
                                                 inListView: $inListView)                                .navigationTitle(list.title)
                                        
                                    } label: {
                                        VStack(alignment: .leading, spacing: 12) {
                                            HStack {
                                                Image(systemName: list.icon)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.white)
                                                    .frame(width: 16, height: 16)
                                                    .padding(10)
                                                    .background(Circle().foregroundStyle(list.color))
                                                    .padding(.trailing, 4)
                                                Spacer()
                                                Text("\(list.sections.count)")
                                                    .foregroundStyle(.white)
                                                    .fontWeight(.bold)
                                                    .font(.title)
                                                //                                        .foregroundStyle(.tertiary)
                                            }
                                            Text(list.title)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.white.secondary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(.regularMaterial)
                                        .cornerRadius(20)
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        
                        List{
                            
                            // Lists
                            ForEach(model.todoLists, id: \.id) { list in
                                HStack {
                                    Image(systemName: list.icon)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .frame(width: 16, height: 16)
                                        .padding(10)
                                        .background(Circle().foregroundStyle(list.color))
                                        .padding(.trailing, 4)
                                    Text(list.title)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                .background(
                                    NavigationLink("", destination:
                                                    ListView(index: model.todoLists.firstIndex(where: { $0.id == list.id }) ?? 0,
                                                             color: list.color,
                                                             globalColor: $selectedColor,
                                                             inListView: $inListView)
                                                        .navigationTitle(list.title))
                                    .opacity(0)
                                )
                                .swipeActions(edge: .leading) {
                                    Button {
                                        model.listSelection = list
                                        model.activeSheet = .createList
                                    } label: {
                                        Text("Edit")
                                    }
                                    .tint(.gray)
                                }
                            }
                            .onDelete(perform: delete)
                            .onMove(perform: move)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .environment(\.defaultMinListRowHeight, 60)
                    }
                }
                .navigationTitle("Lists")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            model.activeSheet = .settings
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.gray)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            
            VStack(spacing: 20) {
//                Menu {
//                    if inListView {
//                        Button(model.showCompleted ? "Hide Completed" : "Show Competed") {
//                            model.showCompleted.toggle()
//                        }
//                        
//                        Divider()
//                        
//                        Button("Edit Sections") {
//                            model.editSections.toggle()
//                        }
//                        Button("Add Section") {
//                            model.showCreateSection.toggle()
//                        }
//                        
//                        Divider()
//                        
//                        Button("Edit List") {
//                            model.showCreateList.toggle()
//                        }
//                        
//                    } else {
//                        Button("Edit Lists") {
//                            model.editLists.toggle()
//                        }
//                        Button("Add List") {
//                            model.showCreateList.toggle()
//                        }
//                    }
//                } label: {
//                    Image(systemName: "ellipsis")
//                        .foregroundStyle(selectedColor)
//                        .fontWeight(.bold)
//                        .padding(14)
//                        .background(Circle().foregroundStyle(.regularMaterial))
//                }
                
                Button {
                    if inListView {
                        model.showCreateSection.toggle()
                    } else {
                        model.activeSheet = .createList
                    }
                    softHaptic()
                } label: {
                    Image(systemName: inListView ? "list.bullet.indent" : "list.bullet")
                        .foregroundStyle(selectedColor)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(11)
                        .background(Circle().foregroundStyle(.regularMaterial))
                }
                
                Button {
                    if inListView {
                        
                    } else {
                        model.listSelection = model.todoLists[0]
                    }
                    model.activeSheet = .createTodo
                    softHaptic()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding(12)
                        .background(Circle().foregroundStyle(selectedColor))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.bottom, 20).padding(.trailing)
            .ignoresSafeArea()
        }
        .accentColor(selectedColor)
        
        .sheet(item: $model.activeSheet) { sheet in
            switch sheet {
                
            case .createTodo:
                CreateTodo(color: selectedColor)
                    .presentationDetents([.fraction(3/10)])
                    .presentationBackground(.ultraThickMaterial)
                    .presentationCornerRadius(40)
                
            case .createList:
                CreateList()
                    .presentationBackground(.black.opacity(0.3))
                    .presentationBackground(.ultraThickMaterial)
                    .presentationCornerRadius(40)
                
            case .createSection:
                VStack{}
                
            case .editLists:
                EditLists()
                    .presentationDetents([.large, .medium])
                    .presentationBackground(.black.opacity(0.2))
                    .presentationBackground(.thickMaterial)
                    .presentationCornerRadius(40)
                    .presentationDragIndicator(.hidden)
                
            case .settings:
                SettingsView()
                    .presentationDetents([.large, .medium])
                    .presentationBackground(.black.opacity(0.2))
                    .presentationBackground(.thickMaterial)
                    .presentationCornerRadius(40)
                    .presentationDragIndicator(.hidden)
            }
        }
    }

    func delete(at offsets: IndexSet) {
        model.todoLists.remove(atOffsets: offsets)
        model.saveToUserDefaults()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.todoLists.move(fromOffsets: source, toOffset: destination)
        model.saveToUserDefaults()
    }
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(descriptor:titleFont.fontDescriptor
            .withDesign(.rounded)? // make rounded
            .withSymbolicTraits(.traitBold) // make bold
                           ??
                           titleFont.fontDescriptor, // return the normal title if customization failed
                           size: titleFont.pointSize
        )
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }
}

#Preview {
    ContentView()
        .environment(Model())
}
