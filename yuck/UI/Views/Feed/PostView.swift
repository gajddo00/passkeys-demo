//
//  PostView.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import SwiftUI

struct PostView: View {
    @Binding var post: Post
        
    var body: some View {
        content()
            .padding(1)
    }
}

// MARK: Components
private extension PostView {
    @ViewBuilder func content() -> some View {
        VStack(spacing: 20) {
            Text(post.content)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                votes()
                
                Spacer()
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.foregroundColor, lineWidth: 2)
        )
    }
    
    @ViewBuilder func votes() -> some View {
        HStack(spacing: 15) {
            Button {
                post.upvote()
            } label: {
                VStack(spacing: 10) {
                    Image(RImage.upvoteIcon.name)
                    Text("\(post.upVotesCount)")
                        .font(.caption)
                        .bold()
                }
            }
            
            Button {
                post.downvote()
            } label: {
                VStack(spacing: 10) {
                    Image(systemSymbol: .chevronDown)
                    Text("\(post.downVotesCount)")
                        .font(.caption)
                        .bold()
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        PostView(post: .constant(Post.mocks.first!))
    }
}
