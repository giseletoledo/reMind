//
//  TodaysCardsView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI
import CoreData

struct TodaysCardsView: View {
    let numberOfPendingCards: Int  // Adiciona a propriedade
        let theme: reTheme
        let selectedBox: Box
        @StateObject private var viewModel: ReviewViewModel
        @State private var showAlert = false
        @State private var navigateToSwipperView = false

        // Atualize o inicializador para aceitar numberOfPendingCards
        init(numberOfPendingCards: Int, theme: reTheme, selectedBox: Box) {
            self.numberOfPendingCards = numberOfPendingCards  // Inicialize a propriedade
            self.theme = theme
            self.selectedBox = selectedBox
            _viewModel = StateObject(wrappedValue: ReviewViewModel(selectedBox: selectedBox))
        }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                // Título
                Text("Today's Cards")
                    .font(.title)
                    .fontWeight(.semibold)

                // Número de termos para revisar
                Text("\(viewModel.review.termsToReview.count) cards to review")
                    .font(.title3)

                // Botão de revisão
                Button(action: {
                    viewModel.fetchReviewData()
                    if viewModel.review.termsToReview.isEmpty {
                        showAlert = true
                    } else {
                        navigateToSwipperView = true
                    }
                }, label: {
                    Text("Start Swipping")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(reColorButtonStyle(theme))
                .padding(.top, 10)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("No Terms"),
                        message: Text("There are no terms available for review."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding(.vertical, 16)
            .onAppear {
                viewModel.fetchReviewData()
            }
            // Navegação para o SwipperView
            .navigationDestination(isPresented: $navigateToSwipperView) {
                SwipperView(termsToReview: viewModel.review.termsToReview)
            }
        }
    }
}



struct TodaysCardsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let request = NSFetchRequest<NSManagedObjectID>(entityName: "Box")

        do {
            let results = try context.fetch(request)
            if let firstBoxID = results.first {
                let selectedBox = try context.existingObject(with: firstBoxID) as! Box
                return AnyView(
                    TodaysCardsView(numberOfPendingCards: 3, theme: .mauve, selectedBox: selectedBox)
                        .environment(\.managedObjectContext, context)
                )
            } else {
                return AnyView(
                    Text("No Box entities found")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
            }
        } catch {
            return AnyView(
                Text("Failed to fetch Box entity: \(error.localizedDescription)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
    }
}

