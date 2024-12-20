//
//  BoxView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI
import CoreData

struct BoxView: View {
    @ObservedObject var viewModel: BoxViewModel
    var box: Box

    var body: some View {
        VStack {
            HeaderView(boxName: box.name ?? "Unknown")
            
            TermsListView(viewModel: viewModel, box: box) // Passando o viewModel
        }
        .navigationTitle("Box Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: BoxEditorView(
                        viewModel: viewModel,
                        name: box.name ?? "",
                        theme: Int(box.rawTheme),
                        delegate: viewModel as? BoxEditorDelegate
                    )
                ) {
                    Text("Edit")
                }
            }
        }
    }
}

struct HeaderView: View {
    let boxName: String

    var body: some View {
        Text(boxName)
            .font(.largeTitle)
            .padding()
    }
}

struct TermsListView: View {
    @ObservedObject var viewModel: BoxViewModel
    var box: Box

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let terms = box.terms as? Set<Term> {
                    ForEach(Array(terms), id: \.self) { term in
                        TermRowView(viewModel: viewModel, term: term, box: box) // Passando o viewModel
                    }
                } else {
                    Text("No terms available")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct TermRowView: View {
    @ObservedObject var viewModel: BoxViewModel
    var term: Term
    var box: Box

    var body: some View {
        HStack {
            Text(term.value ?? "Unknown")
                .font(.body)
            Spacer()
            Text(viewModel.getNumberOfPendingTerms(of: box)) // Chamando o método já presente
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
        .swipeActions {
            Button(role: .destructive) {
                viewModel.deleteBox(box)// Chamando o método deletar
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}



struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BoxViewModel()
        let box = Box(context: CoreDataStack.inMemory.managedContext)
        box.name = "Sample Box"
        box.rawTheme = 1

        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "Sample Term"
        term.lastReview = Date()
        box.addToTerms(term)

        return NavigationStack {
            BoxView(viewModel: viewModel, box: box)
        }
    }
}
