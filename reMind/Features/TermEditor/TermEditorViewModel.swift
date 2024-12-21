//
//  TermEditorViewModel.swift
//  reMind
//
//  Created by GISELE TOLEDO on 19/12/24.
//

import SwiftUI
import CoreData

class TermEditorViewModel: ObservableObject {
    @Published var term: Term
    var isEditing: Bool
    
    init(term: Term? = nil) {
        if let term = term {
            self.term = term
            self.isEditing = true
        } else {
            self.term = Term(context: CoreDataStack.shared.managedContext)
            self.isEditing = false
        }
    }
    
    func save() {
        do {
            try CoreDataStack.shared.managedContext.save()
        } catch {
            print("Failed to save term: \(error)")
        }
    }
    
    func delete() {
        if isEditing {
            CoreDataStack.shared.managedContext.delete(term)
            save()
        }
    }
}
