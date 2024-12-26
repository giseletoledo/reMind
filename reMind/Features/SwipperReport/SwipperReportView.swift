//
//  SwipperReportView.swift
//  reMind
//
//  Created by GISELE TOLEDO on 26/12/24.
//

import SwiftUI

struct SwipperReportView: View {
    var reviewedTerms: [Term]

    var body: some View {
        VStack {
            Text("Review Report")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(reviewedTerms, id: \.self) { term in
                    CardTermView(term: term.value ?? "Term", meaning: term.meaning ?? "Meaning", isReviewed: true)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(reBackground())
    }
}
