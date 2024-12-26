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
    @State var value: String = ""
    @State var meaning: String = ""
    var term: Term? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                reTextField(title: "Term", text: $value)
                reTextEditor(title: "Meaning", text: $meaning, maxSize: 150)

                Spacer()

                if term == nil {
                    Button("Save and Add New") {
                        viewModel.addTerm(value: value, meaning: meaning)
                        value = ""
                        meaning = ""
                    }
                    .buttonStyle(reButtonStyle())
                }else {
                    Button("Delete Term") {
                        if let term = term {
                            viewModel.removeTerm(term)
                        }
                        dismiss()
                    }
                    .buttonStyle(reButtonStyle())
                    .foregroundColor(.red)
                }
            }
            .padding()
            .background(reBackground())
            .navigationTitle(term == nil ? "New Term" : "Edit Term")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let term = term {
                            viewModel.updateTerm(term: term, value: value, meaning: meaning)
                        } else {
                            viewModel.addTerm(value: value, meaning: meaning)
                        }
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                if let term = term {
                    value = term.value ?? ""
                    meaning = term.meaning ?? ""
                }
            }
        }
    }
}


struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TermEditorView(viewModel: TermEditorViewModel(term: Term(context: CoreDataStack.shared.managedContext)))
    }
}
