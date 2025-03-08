//
//  AppView.swift
//  ToDoBar
//
//  Created by Pavel Makhov on 2025-02-24.
//

import SwiftUI

struct AppView: View {
    @Environment(\.openURL) var openURL

    let app: App
    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 0) {
            Image(app.iconName)
                .resizable()
                .frame(width: 64, height: 64)
            
            Text(app.name)
                .font(.caption)
        }
        .padding(8)
        .background(isHovered ? Color.gray.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .onTapGesture {
            openURL(URL(string: app.appStoreURL)!)
        }
    }
}

//#Preview {
//    AppView()
//}
