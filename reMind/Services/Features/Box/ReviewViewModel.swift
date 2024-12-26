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

    init() {
        self.review = SwipeReview(termsToReview: [])
        fetchReviewData()
    }

    func fetchReviewData() {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        
        do {
            let terms = try CoreDataStack.shared.managedContext.fetch(fetchRequest)
            self.review = SwipeReview(termsToReview: terms)
        } catch {
            print("Failed to fetch terms: \(error)")
        }
    }
}
