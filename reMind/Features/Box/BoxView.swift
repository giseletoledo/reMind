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
    @ObservedObject var box: Box
    
    @State private var searchText: String = ""
    @State private var isCreatingTerm: Bool = false
    @State private var isEditingBox: Bool = false
    
    private var filteredTerms: [Term] {
        let terms = box.terms as? Set<Term> ?? []
        if searchText.isEmpty {
            return Array(terms)
        } else {
            return terms.filter { ($0.value ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            // Background ocupa toda a área
            reBackground()
                .ignoresSafeArea() // Garante que o fundo cobre toda a tela
            
            VStack(alignment: .leading, spacing: 16) {
                // Barra de busca
                SearchBar(searchText: $searchText)
                
                // Exibição do Today's Card
                TodaysCardsView(numberOfPendingCards:
                                viewModel.getNumberOfPendingTerms(of: box).count,
                                theme: box.theme,
                                selectedBox: box)
                    .padding(.horizontal) // Adiciona padding nas laterais
                
                // Lista de termos filtrados ou mensagem de ausência
                if filteredTerms.isEmpty {
                    Text("No terms available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    TermsListView(viewModel: viewModel, terms: filteredTerms, box: box)
                }
                Spacer()
            }
            .scrollContentBackground(.hidden) // Oculta fundo de rolagem padrão
        }
        .navigationTitle(box.name ?? "Unknown")
        .searchable(text: $searchText, prompt: "")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isEditingBox.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
                Button {
                    isCreatingTerm.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isEditingBox) {
            BoxEditorView(
                viewModel: viewModel,
                identifier: box.identifier, // Passa o identifier existente
                name: box.name ?? "",
                keywords: box.keywords ?? "",
                description: box.boxDescription ?? "",
                theme: box.theme.rawValue,
                delegate: viewModel
            )
        }
        .sheet(isPresented: $isCreatingTerm) {
            TermEditorView(viewModel: TermEditorViewModel(box: box))
        }
    }
}

// Barra de busca personalizada
struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        TextField("Search terms", text: $searchText)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

struct TermsListView: View {
    @ObservedObject var viewModel: BoxViewModel
    var terms: [Term]
    var box: Box

    var body: some View {
        List {
            ForEach(terms, id: \.self) { term in
                TermRowView(viewModel: viewModel, term: term, box: box, delegate: viewModel)
            }
        }
        .listStyle(PlainListStyle()) // Use PlainListStyle para controlar a aparência da lista
    }
}

struct TermRowView: View {
    @ObservedObject var viewModel: BoxViewModel
    var term: Term
    var box: Box

    weak var delegate: TermEditingDelegate?  // Declara o delegate

    @State private var termValue: String

    init(viewModel: BoxViewModel, term: Term, box: Box, delegate: TermEditingDelegate?) {
        self.viewModel = viewModel
        self.term = term
        self.box = box
        self._termValue = State(initialValue: term.value ?? "")
        self.delegate = delegate
    }

    var body: some View {
        HStack {
            TextField("Term", text: $termValue)
                .font(.body)
                .onChange(of: termValue) { newValue in
                    delegate?.didEditTerm(term, newValue: newValue)  // Chamando o delegate quando o valor for alterado
                }
            Spacer()
            Text("\(viewModel.getNumberOfPendingTerms(of: box))")  // Atualiza com base no box associado
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
        .swipeActions(edge: .trailing) {  // Certifique-se de que o swipeActions está corretamente aplicado
            Button(role: .destructive) {
                delegate?.didDeleteTerm(term)  // Chamando o delegate para deletar o termo
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}


// Previews
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
