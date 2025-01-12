//
//  ContentView.swift
//  ToDo
//  Created by Developer on 8/3/24.
//

import SwiftUI
import SwiftData
import Introspect

struct ContentView: View {
    @State var model = Model()
    @State var ShowCreateList = false
    @State var showCreateTodo = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                List{
                    ForEach(model.todoLists) { list in
                        NavigationLink {
                            HStack(spacing: 0) {
                                ScrollView {
                                    VStack(spacing: 20) {
                                        ForEach(list.sections) { section in
                                            ToDoItem(model: model, list: section)
                                        }
                                    }
                                    .padding(.top, 8)
                                }
                                .scrollIndicators(.hidden)
                            }
                            .navigationTitle(list.title)
                            
                        } label: {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .font(.callout)
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                                    .padding(10)
                                    .background(Circle().foregroundStyle(.teal))
                                Text(list.title)
                                Spacer()
                                Text("\(list.sections.count)")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.leading, -2)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
                .navigationTitle("Lists")
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 68)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Button("Create List") {
                                ShowCreateList.toggle()
                            }
                            Button("Edit Lists") {
                                
                            }
                            Divider()
                            Text("Settings")
                        } label: {
                            Image(systemName: "ellipsis")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            
            Button {
                showCreateTodo.toggle()
                softHaptic()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(14)
                    .background(Circle().foregroundStyle(.teal))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.bottom, 20).padding(.trailing)
            .ignoresSafeArea()
            
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.teal)
                    .font(.largeTitle)
                Text("Added to ")
                    .font(.title3)
                    .fontWeight(.medium)
                Spacer()
                Text("Life")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.teal)
                Image(systemName: "chevron.down")
                    .font(.footnote)
                    .foregroundStyle(.teal)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 64)
                    .stroke(Color.gray.opacity(0.8), lineWidth: 3)
            )
            .cornerRadius(64)
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .top)
            .offset(y: model.placeTodo ? 0 : -158)
            .animation(.bouncy(duration: 0.4), value: model.placeTodo)
        }
        .sheet(isPresented: $showCreateTodo) {
            CreateTodo(model: model)
                .presentationDetents([.fraction(3.5/10)])
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(36)
        }
        .sheet(isPresented: $ShowCreateList) {
            CreateTodoList(model: model)
                .presentationDetents([.fraction(1/3)])
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(36)
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
}

#Preview {
    ContentView()
        .accentColor(.teal)
}

func lightHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .light)
    impactLit.impactOccurred()
}

func medHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .medium)
    impactLit.impactOccurred()
}

func softHaptic() {
    let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    impactSoft.impactOccurred()
}
