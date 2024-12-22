//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//
// update 19/12/24.

import SwiftUI

struct BoxEditorView: View {
    @ObservedObject var viewModel: BoxViewModel
    @State var identifier: UUID? // Identificador opcional para edição
    @State var name: String
    @State var keywords: String
    @State var description: String
    @State var theme: Int
    weak var delegate: BoxEditorDelegate?
    
    // Ambiente para dismiss
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Campos de entrada de dados
                reTextField(title: "Name", text: $name)
                reTextField(title: "Keywords",
                            caption: "Separated by , (comma)",
                            text: $keywords)
                reTextEditor(title: "Description", text: $description)
                reRadioButtonGroup(title: "Theme", currentSelection: $theme)
                
                Spacer()
            }
            .padding()
            .background(reBackground())
            .navigationTitle("New Box")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Botão "Cancel"
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        delegate?.didCancel()  // Chama o método de cancelamento
                        dismiss()               // Dismissa a view
                    }
                }
                
                // Botão "Save"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addOrEditBox(
                            identifier: identifier, // Passa o identifier para edição
                            name: name,
                            keywords: keywords,
                            description: description,
                            theme: theme) // Chama a função para salvar
                        dismiss()  // Dismiss a view
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}

struct BoxEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BoxEditorView(viewModel: BoxViewModel(),
                      name: "",
                      keywords: "",
                      description: "",
                      theme: 0,
                      delegate: nil)
    }
}

