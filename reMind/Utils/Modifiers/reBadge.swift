//
//  reBadge.swift
//  reMind
//
//  Created by Pedro Sousa on 28/06/23.
//

import SwiftUI

struct reBadgeModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    var value: String

    private var textColor: Color {
        colorScheme == .light ? Palette.reWhite.render : Palette.reBlack.render
    }

    private var backgroundColor: Color {
        colorScheme == .light ? Palette.reBlack.render : Palette.reWhite.render
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) { // Posiciona o badge no topo à direita
            content
            if !value.isEmpty {
                Text(value)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .padding(8)
                    .background {
                        Circle()
                            .fill(backgroundColor)
                    }
                    .offset(x: 0, y: -15) // Ajusta a posição no canto superior direito
            }
        }
    }
}

extension View {
    func reBadge(_ value: String) -> some View {
        self.modifier(reBadgeModifier(value: value))
    }
}
