//
//  SignUpScreen.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import SwiftUI
import Combine

struct SignUpScreen: View {
    @StateObject private var store: SignUpStore
    
    init(store: SignUpStore) {
        self._store = StateObject(wrappedValue: store)
    }
}

// MARK: - Body
extension SignUpScreen {
    var body: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            
            content()
                .padding(.top, 40)
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(RString.generalName())
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Image(RImage.glassesIcon.name)
                }
            }
        }
    }
}

// MARK: - Components
private extension SignUpScreen {
    @ViewBuilder func content() -> some View {
        VStack(spacing: 30) {
            username()
            
            emojiPicker()
            
            Spacer()
            
            Button(RString.signupButtonTitle()) {
                store.send(action: .didTapSignUp)
            }
            .primaryButtonGray()
        }
    }
    
    @ViewBuilder func username() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(RString.signupUsernameTitle())
                .font(.body)
            
            Text(RString.signupUsernameTip())
                .font(.caption2)
            
            TextField(RString.generalUsername(), text: store.binding(for: \.username, send: { .usernameDidChange($0) }))
            .primaryTextField()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func emojiPicker() -> some View {
        VStack(alignment: .leading) {
            Text(RString.signupEmojiTitle())
                .font(.body)
            
            EmojiPicker(
                items: EmojiItem.data,
                pickedEmoji: store.binding(for: \.emoji, send: { .emojiDidChange($0) })
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Private
private extension SignUpScreen {
    
}

// MARK: - Preview
struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(store: SignUpStore(authenticationService: AuthenticationService.mock))
    }
}
