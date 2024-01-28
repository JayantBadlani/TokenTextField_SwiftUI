//
//  TokenModel.swift
//
//  Created by Jayant on 11/01/24.
//

import Foundation
import SwiftUI


struct TokenModel: Identifiable, Hashable, Equatable {
    
    var id: UUID = UUID()
    var value: String
    var isSelected: Bool = false
    var convertedToToken = true

    static func == (lhs: TokenModel, rhs: TokenModel) -> Bool {
        return lhs.id == rhs.id && lhs.value == rhs.value && lhs.isSelected == rhs.isSelected && lhs.convertedToToken == rhs.convertedToToken
    }
}
