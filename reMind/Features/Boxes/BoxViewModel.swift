//
//  BoxViewModel.swift
//  reMind
//
//  Created by Pedro Sousa on 17/07/23.
//
//  Updated by Gisele Toledo on 19/12/24.

import SwiftUI
import CoreData

class BoxViewModel: ObservableObject, BoxViewModellingProtocol {
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
    
    // Função para obter o número de termos pendentes de revisão
    func getNumberOfPendingTerms(of box: Box) -> String {
        let termSet = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = termSet.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count == 0 ? "" : "\(filteredTerms.count)"
    }
    
    // Função para adicionar uma nova caixa
    func addBox(name: String, theme: Int16) {
        let newBox = Box(context: CoreDataStack.shared.managedContext)
        newBox.identifier = UUID()
        newBox.name = name
        newBox.rawTheme = theme
        saveContext() // Salva a nova caixa no contexto
        fetchBoxes()  // Atualiza a lista de caixas
    }
    
    // Função para deletar uma caixa
    func deleteBox(_ box: Box) {
        CoreDataStack.shared.managedContext.delete(box)
        saveContext()
        fetchBoxes()
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
