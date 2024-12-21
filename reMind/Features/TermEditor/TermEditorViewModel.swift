//
//  TermEditorViewModel.swift
//  reMind
//
//  Created by GISELE TOLEDO on 19/12/24.
//

import Foundation
import CoreData

class TermEditorViewModel: ObservableObject {
    @Published var terms: [Term] = []
        var term: Term?
        var box: Box? // Adiciona a referência à Box
        var isEditing: Bool = false

        init(term: Term? = nil, box: Box? = nil, isEditing: Bool = false) {
            self.term = term
            self.box = box
            self.isEditing = isEditing
            fetchTerms()
        }

    
    func addTerm(value: String, meaning: String?) {
            guard let box = box else { return } // Certifica-se de que a Box existe

            let newTerm = Term(context: CoreDataStack.shared.managedContext)
            newTerm.value = value
            newTerm.meaning = meaning
            newTerm.creationDate = Date()
            newTerm.identifier = UUID()
            newTerm.boxID = box // Define a relação com a Box
            box.addToTerms(newTerm) // Adiciona o novo termo à relação da Box
            saveContext()
            fetchTerms()
        }

        func updateTerm(term: Term, value: String, meaning: String?) {
            term.value = value
            term.meaning = meaning
            term.lastReview = Date() // Atualize a data da última revisão
            saveContext()
            fetchTerms()
        }

        func removeTerm(_ term: Term) {
            CoreDataStack.shared.managedContext.delete(term)
            saveContext()
            fetchTerms()
        }
    
    func fetchTerms() {
        let request: NSFetchRequest<Term> = Term.fetchRequest()
        do {
            terms = try CoreDataStack.shared.managedContext.fetch(request)
        } catch {
            print("Failed to fetch terms: \(error)")
        }
    }

    func saveContext() {
        do {
            try CoreDataStack.shared.managedContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
