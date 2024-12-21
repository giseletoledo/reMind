//
//  BoxEditorDelegate.swift
//  reMind
//
//  Created by GISELE TOLEDO on 19/12/24.
//

import Foundation

protocol BoxEditorDelegate: AnyObject {
    func didAddBox(name: String, keywords: String, description: String, theme: Int)
    func didCancel()
}
