//
//  BoxViewModel.swift
//  reMind
//
//  Created by Pedro Sousa on 17/07/23.
//
//  Updated by Gisele Toledo on 19/12/24.

import SwiftUI
import CoreData

class BoxViewModel: BoxViewModellingProtocol, TermEditingDelegate, BoxEditorDelegate {
   
    @Published var boxes: [Box] = []

    init() {
        fetchBoxes()
    }
    
    // Função para buscar caixas
    func fetchBoxes() {
        let request: NSFetchRequest<Box> = Box.fetchRequest()
        do {
            boxes = try CoreDataStack.shared.managedContext.fetch(request)
        } catch {
            print("Failed to fetch boxes: \(error)")
        }
    }
    
    
    // Função chamada ao cancelar a edição ou adição de uma caixa
    func didCancel() {
        // Ação a ser realizada ao cancelar (se necessário)
    }
    // Função para deletar uma caixa
        func deleteBox(_ box: Box) {
            CoreDataStack.shared.managedContext.delete(box)
            saveContext()
            fetchBoxes()
        }
        
    func didEditTerm(_ term: Term, newValue: String) {
        term.value = newValue
        term.lastReview = Date() // Atualiza a data da última revisão
        saveContext()

        // Recalcula os dados da caixa que contém o termo atualizado
        if let box = term.boxID {
            updatePendingTerms(for: box)
        }
    }
    
    private func updatePendingTerms(for box: Box) {
        guard let termSet = box.terms as? Set<Term> else { return } // Obtém os termos relacionados
        let today = Date()

        // Filtra os termos que estão pendentes
        let filteredTerms = termSet.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        // Atualiza o número de termos pendentes diretamente no Core Data
        box.setValue(Int16(filteredTerms.count), forKey: "numberOfPendingTerms")
        saveContext()
    }

        // Método para deletar o termo
        func didDeleteTerm(_ term: Term) {
            CoreDataStack.shared.managedContext.delete(term)
            saveContext()
            fetchBoxes() // Atualize os dados após deletar
        }
   
    
    func addOrEditBox(
        identifier: UUID? = nil,
        name: String,
        keywords: String,
        description: String,
        theme: Int
    ) {
        if let identifier = identifier,
           let existingBox = boxes.first(where: { $0.identifier == identifier }) {
            // Atualiza a caixa existente
            existingBox.name = name
            existingBox.keywords = keywords
            existingBox.boxDescription = description
            existingBox.rawTheme = Int16(theme)
        } else {
            // Cria uma nova caixa
            let newBox = Box(context: CoreDataStack.shared.managedContext)
            newBox.identifier = UUID()
            newBox.name = name
            newBox.keywords = keywords
            newBox.boxDescription = description
            newBox.rawTheme = Int16(theme)
        }
        // Salva as mudanças e atualiza a lista de caixas
        saveContext()
        fetchBoxes()
    }

    func getNumberOfPendingTerms(of box: Box) -> Int {
        let termSet = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = termSet.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count
    }

    
    // Função para salvar o contexto
    private func saveContext() {
        do {
            try CoreDataStack.shared.managedContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
