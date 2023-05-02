//
//  FeedStore.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import Combine

@MainActor
final class FeedStore: Store, ObservableObject, SubscriptionCancellable {
    typealias State = FeedState
    typealias Action = FeedAction
    
    // MARK: Public
    @Published private(set) var state: FeedState = .init()
    var cancellables: Set<AnyCancellable> = []

    // MARK: Private
    private var eventSubject = PassthroughSubject<Event, Never>()
    
    func send(action: FeedAction) {
        switch action {
        case .viewDidLoad:
            Task { await loadPosts() }
            
        case let .postDidUpdate(post):
            var posts = state.posts
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts.remove(at: index)
                posts.insert(post, at: index)
                state.posts = posts
            }
        }
    }
}

// MARK: Private
private extension FeedStore {
    func loadPosts() async {
        // For now, load all of them. Add paging later.
        state.posts = Post.mocks
    }
}

// MARK: Events
extension FeedStore: EventEmitting {
    enum Event {
        
    }
    
    var eventPublisher: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: Actions
enum FeedAction {
    case viewDidLoad
    case postDidUpdate(Post)
}

// MARK: Store
struct FeedState: StoreState {
    var isLoading = false
    var posts: [Post] = []
}
