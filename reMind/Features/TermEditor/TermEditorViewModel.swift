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

    init(term: Term) {
        self.term = term
    }

    func save() {
        do {
            try CoreDataStack.shared.managedContext.save()
        } catch {
            print("Failed to save term: \(error)")
        }
    }
}
