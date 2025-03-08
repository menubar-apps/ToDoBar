//
//  DeleteButton.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct DeleteButton: View {
    let isHovered: Bool
    var onClick: () -> Void
    var onHover: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            onClick()
        }) {
            Image(systemName: "trash.circle")
                .resizable()
                .frame(width: 18, height: 18)
                .padding(.top, 1)
                .foregroundColor(isHovered ? .primary : .secondary)
                .opacity(isHovered ? 1 : 0.2)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover(perform: onHover)
    }
}

//#Preview {
//    DeleteButton()
//}
