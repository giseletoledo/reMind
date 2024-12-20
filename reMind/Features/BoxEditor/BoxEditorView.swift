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
    @State var name: String
    @State var theme: Int
    weak var delegate: BoxEditorDelegate?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                reTextField(title: "Name", text: $name)
                reRadioButtonGroup(title: "Theme",
                                   currentSelection: $theme)
                Spacer()
            }
            .padding()
            .background(reBackground())
            .navigationTitle("New Box")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        delegate?.didCancel()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBox()
                        delegate?.didAddBox()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }

    // Função para salvar a nova caixa
    private func saveBox() {
        viewModel.addBox(name: name, theme: Int16(theme))
    }
}

struct BoxEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BoxEditorView(viewModel: BoxViewModel(),
                      name: "",
                      theme: 0)
    }
}
