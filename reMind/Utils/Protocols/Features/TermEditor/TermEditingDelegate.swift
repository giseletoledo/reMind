//
//  TermEditingDelegate.swift
//  reMind
//
//  Created by GISELE TOLEDO on 20/12/24.
//

import Foundation

protocol TermEditingDelegate: AnyObject {
    func didEditTerm(_ term: Term, newValue: String)
    func didDeleteTerm(_ term: Term)
}
