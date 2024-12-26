//
//  SwipperView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct SwipperView: View {
    var termsToReview: [Term]
    @State private var direction: SwipperDirection = .none

    var body: some View {
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
            } else {
                Text("No terms to review")
            }

            Spacer()

            Button(action: {
                print("finish review")
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
