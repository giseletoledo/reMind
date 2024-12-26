//
//  CardTermView.swift
//  reMind
//
//  Created by GISELE TOLEDO on 18/12/24.
//

import SwiftUI

struct CardTermView: View {
    @State private var isExpanded: Bool = false
    var term: String
    var meaning: String
    var isReviewed: Bool
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 0) {
                Text(meaning)
                    .foregroundColor(Palette.reBlack.render)
                    .padding(.vertical, 5.5)
                    .padding(.horizontal, 10)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 108)
        } label: {
            Label {
                Text(term)
            } icon: {
                Image(systemName: isReviewed ? "checkmark.circle" : "xmark.circle")
                    .padding(.leading, 20)
            }
            .frame(alignment: .leading)
            .frame(height: 59.89)
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(Palette.reBlack.render)
        }
        .listRowInsets(.init(top: 0, leading: -20, bottom: 0, trailing: 0))
        .padding(.horizontal, 20)
        .background(isReviewed ? Palette.success.render : Palette.error.render)
    }
}

// Preview of CardTermView
struct CardTermView_Previews: PreviewProvider {
    static var term: String = "Math"
    static var meaning: String = "The meaning goes here"
    
    static var previews: some View {
        List {
            Section {
                ForEach(1...2, id: \.self) { _ in
                    CardTermView(term: term, meaning: meaning, isReviewed: true)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .shadow(color: Palette.reBlack.render.opacity(0.23), radius: 6)
    }
}
