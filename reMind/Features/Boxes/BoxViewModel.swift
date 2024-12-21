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
    
    // Função para adicionar uma nova caixa com nome e tema
    func addBox(name: String, theme: Int16) {
        let newBox = Box(context: CoreDataStack.shared.managedContext)
        newBox.identifier = UUID()
        newBox.name = name
        newBox.rawTheme = theme
        saveContext()
        fetchBoxes()
    }
    
    // Função para adicionar uma nova caixa com mais parâmetros
    func addBox(name: String, keywords: String, description: String, theme: Int) {
        // Criação do objeto Box no contexto do Core Data
        let newBox = Box(context: CoreDataStack.shared.managedContext)
        
        // Configuração dos valores do Box
        newBox.name = name
        newBox.keywords = keywords
        newBox.boxDescription = description
        newBox.rawTheme = Int16(theme)
        
        // Salvando o contexto e atualizando a lista de caixas
        saveContext()
        fetchBoxes()
    }

    
    // Função chamada ao adicionar uma caixa através do editor
    func didAddBox(name: String, keywords: String, description: String, theme: Int) {
        let newBox = Box(context: CoreDataStack.shared.managedContext)
        newBox.identifier = UUID()
        newBox.name = name
        newBox.keywords = keywords
        newBox.boxDescription = description
        newBox.rawTheme = Int16(theme)
        saveContext()
        fetchBoxes()
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
    
    // Implementação do protocolo TermEditingDelegate
    func didEditTerm(_ term: Term, newValue: String) {
        term.value = newValue
        saveContext()
    }

    // Método para deletar o termo
    func didDeleteTerm(_ term: Term) {
        CoreDataStack.shared.managedContext.delete(term)
        saveContext()
    }
    
    // Função para deletar um termo
    func deleteTerm(_ term: Term) {
        CoreDataStack.shared.managedContext.delete(term)
        saveContext()
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
    
    // Função para salvar o contexto
    private func saveContext() {
        do {
            try CoreDataStack.shared.managedContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
