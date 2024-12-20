//
//  BoxViewModellingProtocol.swift
//  reMind
//
//  Created by GISELE TOLEDO on 19/12/24.
//

import Foundation

protocol BoxViewModellingProtocol: ObservableObject {
    var boxes: [Box] { get }
    func fetchBoxes()
    func addBox(name: String, theme: Int16)
    func deleteBox(_ box: Box)
    func getNumberOfPendingTerms(of box: Box) -> String
}
