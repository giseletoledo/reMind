//
//  SwipperView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI


struct SwipperView: View {
    @State private var termsToReview: [Term]
    @State private var direction: SwipperDirection = .none
    @State private var isReviewFinished = false
    @State private var reviewedTerms: [Term] = []
    
    init(termsToReview: [Term]) {
           self._termsToReview = State(initialValue: termsToReview)
       }

    var body: some View {
        NavigationStack {
            VStack {
                SwipperLabel(direction: $direction)
                    .padding()

                Spacer()

                // Verifique se há termos para revisar
                if let firstTerm = termsToReview.first {
                    SwipperCard(direction: $direction,
                                frontContent: {
                                    Text(firstTerm.value ?? "Term")
                                }, backContent: {
                                    Text(firstTerm.meaning ?? "Meaning")
                                })
                    .onChange(of: direction) { newDirection in
                        if newDirection == .left {
                            // Ação para "ainda estou aprendendo este termo"
                            termsToReview.append(firstTerm)
                        } else if newDirection == .right {
                            // Ação para "eu lembro deste termo"
                            reviewedTerms.append(firstTerm)
                        }
                        termsToReview.removeFirst()
                        direction = .none // Reset direction after handling swipe
                    }
                } else {
                    Text("No terms to review")
                }

                Spacer()

                Button(action: {
                    // Ação ao finalizar a revisão
                    isReviewFinished = true
                }, label: {
                    Text("Finish Review")
                        .frame(maxWidth: .infinity, alignment: .center)
                })
                .buttonStyle(reButtonStyle())
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(reBackground())
            .navigationTitle("\(termsToReview.count) terms left")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isReviewFinished) {
                SwipperReportView(reviewedTerms: reviewedTerms)
            }
        }
    }
}

struct SwipperView_Previews: PreviewProvider {
    static var previews: some View {
        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "Sample Term"
        term.meaning = "Sample Meaning"
        
        return NavigationStack {
            SwipperView(termsToReview: [term])
        }
    }
}
