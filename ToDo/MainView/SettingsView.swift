//
//  SettingsView.swift
//  ToDo
//
//  Created by Developer on 10/12/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Model.self) var model

    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            VStack {
                Toggle("Large View", isOn: $model.largeView)
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
