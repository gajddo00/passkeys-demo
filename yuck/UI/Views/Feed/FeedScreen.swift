//
//  FeedScreen.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import SwiftUI
import Combine

struct FeedScreen: View {
    @StateObject private var store: FeedStore
    
    init(store: FeedStore) {
        self._store = StateObject(wrappedValue: store)
    }
}

// MARK: - Body
extension FeedScreen {
    var body: some View {
        ZStack {
            Color.backgroundColor
            
            content()
                .padding(.top, 30)
        }
        .onFirstAppear {
            store.send(action: .viewDidLoad)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(RString.feedTitle())
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Components
private extension FeedScreen {
    @ViewBuilder func content() -> some View {
        VStack {
            posts()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func posts() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(store.state.posts, id: \.id) { post in
                    PostView(post: .init(get: {
                        post
                    }, set: { uPost in
                        store.send(action: .postDidUpdate(uPost))
                    }))
                }
            }
        }
    }
}

// MARK: - Private
private extension FeedScreen {
    
}

// MARK: - Preview
struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedScreen(store: FeedStore())
    }
}
