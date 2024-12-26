//
//  ReviewViewModel.swift
//  reMind
//
//  Created by GISELE TOLEDO on 21/12/24.
//

import SwiftUI
import CoreData

class ReviewViewModel: ObservableObject {
    @Published var review: SwipeReview
    private var selectedBox: Box

    init(selectedBox: Box) {
        self.selectedBox = selectedBox
        self.review = SwipeReview(termsToReview: [])
        fetchReviewData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidChange), name: .NSManagedObjectContextObjectsDidChange, object: CoreDataStack.shared.managedContext)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSManagedObjectContextObjectsDidChange, object: CoreDataStack.shared.managedContext)
    }

    @objc private func contextDidChange(notification: Notification) {
        fetchReviewData()
    }

    func fetchReviewData() {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        fetchRequest.fetchLimit = 3  // Limitar a quantidade de termos a 3
        fetchRequest.predicate = NSPredicate(format: "boxID == %@", selectedBox)
        
        do {
            let terms = try CoreDataStack.shared.managedContext.fetch(fetchRequest)
            self.review = SwipeReview(termsToReview: terms)
        } catch {
            print("Failed to fetch terms: \(error)")
        }
    }
}
