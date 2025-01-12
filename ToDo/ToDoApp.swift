//
//  ToDoApp.swift
//  ToDo
//
//  Created by Developer on 8/3/24.
//

import SwiftUI

@main
struct ToDoApp: App {
    @State var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
                .accentColor(.mint)
                .environment(model)
        }
    }
}
