//
//  TermEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 30/06/23.
//

import SwiftUI

struct TermEditorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TermEditorViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            reTextField(
                title: "Term",
                text: Binding(
                    get: { viewModel.term.value ?? "" },
                    set: { viewModel.term.value = $0 }
                )
            )
            reTextEditor(
                title: "Meaning",
                text: Binding(
                    get: { viewModel.term.meaning ?? "" },
                    set: { viewModel.term.meaning = $0 }
                )
            )
            
            Spacer()

            Button(action: {
                viewModel.save()
                // Adicionar lógica para adicionar um novo termo se necessário
            }, label: {
                Text("Save and Add New")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(reButtonStyle())
        }
        .padding()
        .background(reBackground())
        .navigationTitle("New Term")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss() // Fechar a tela e voltar para a anterior
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.save()
                    dismiss() // Salvar e fechar a tela
                }
                .fontWeight(.bold)
            }
        }
    }
}

struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "Term"
        term.meaning = "Meaning"
        return NavigationStack {
            TermEditorView(viewModel: TermEditorViewModel(term: term))
        }
    }
}
