//
//  TermEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 30/06/23.
//

import SwiftUI


struct TermEditorView: View {
    @ObservedObject var viewModel: TermEditorViewModel
    @State private var termValue: String = ""

    var body: some View {
        VStack {
            TextField("Term Value", text: $termValue)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                viewModel.term.value = termValue
                viewModel.save()
            }) {
                Text(viewModel.isEditing ? "Update Term" : "Create Term")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if viewModel.isEditing {
                Button(action: {
                    viewModel.delete()
                }) {
                    Text("Delete Term")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            self.termValue = viewModel.term.value ?? ""
        }
    }
}

struct TermEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TermEditorView(viewModel: TermEditorViewModel(term: Term(context: CoreDataStack.shared.managedContext)))
    }
}
