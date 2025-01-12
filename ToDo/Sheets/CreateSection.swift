//
//  CreateSection.swift
//  ToDo
//  Created by Developer on 10/6/24.
//

import SwiftUI

struct CreateSection: View {
    @Environment(Model.self) var model
    
    @State var list: TodoList
    @State var color: Color
    @State var sectionTitle = ""
    
    var body: some View {
        VStack {
            
            Image(systemName: "list.bullet.indent")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(color)
            
            Spacer()
            
            TextField("New Section", text: $sectionTitle)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
                .focused($isFocused)
                .introspectTextField { textField in textField.becomeFirstResponder() }
            
            Spacer()
            
            Button {
                model.createSection(list: list, title: sectionTitle)
                medHaptic()
                dismiss()
            } label : {
                Text("Create Section")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(color)
                    .cornerRadius(20)
            }
        }
        .padding()
    }
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
}

#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true)) {
            CreateSection(list: Model().todoLists[0], color: .green)
                .presentationDetents([.fraction(1/3)])
                .presentationBackground(.black.opacity(0.2))
                .presentationBackground(.thickMaterial)
                .presentationCornerRadius(40)
        }
}
