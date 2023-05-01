//
//  CreatePostScreen.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import SwiftUI
import Combine

struct CreatePostScreen: View {
    @StateObject private var store: CreatePostStore
    
    init(store: CreatePostStore) {
        self._store = StateObject(wrappedValue: store)
    }
}

// MARK: - Body
extension CreatePostScreen {
    var body: some View {
        ZStack {
            Color.backgroundColor
            
            Text("Create Post...")
        }
    }
}

// MARK: - Components
private extension CreatePostScreen {
    @ViewBuilder func content() -> some View {
        
    }
}

// MARK: - Private
private extension CreatePostScreen {
    
}

// MARK: - Preview
struct CreatePostScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostScreen(store: CreatePostStore())
    }
}
