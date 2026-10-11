//
//  DeleteButton.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct DeleteButton: View {
    var onClick: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: {
            onClick()
        }) {
            Image(systemName: "trash.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isHovered ? .primary : .secondary)
                .opacity(isHovered ? 1 : 0.6)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { isHovered = $0 }
        .accessibilityLabel(Text("Delete task"))
    }
}

//#Preview {
//    DeleteButton()
//}
