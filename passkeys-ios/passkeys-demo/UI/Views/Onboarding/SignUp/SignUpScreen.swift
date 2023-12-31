//
//  SignUpScreen.swift
//  PasskeysDemo
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
                }
            }
        }
    }
}

// MARK: - Components
private extension SignUpScreen {
    @ViewBuilder func content() -> some View {
        VStack(spacing: 30) {
            usernameInput()

            Spacer()
            
            Button(store.state.mode == .signup ? RString.signupButtonTitle() : RString.signinButtonTitle()) {
                store.send(action: .didTapSignUp)
            }
            .primaryButtonGray()
            .disabled(store.state.username.isEmpty)
        }
        .animation(.linear(duration: 0.2), value: store.state.mode)
    }
    
    @ViewBuilder func usernameInput() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(store.state.mode == .signup ? RString.signupUsernameTitle() : RString.signinUsernameTitle())
                .font(.body)
            
            if store.state.mode == .signup {
                Text(RString.signupUsernameTip())
                    .font(.caption2)
            }
            
            TextField(RString.generalUsername(), text: $store.username)
                .onReceive(store.$username
                    .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)) { newValue in
                        store.send(action: .usernameDidChange(newValue))
                }
                .primaryTextField()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Preview
struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(store: SignUpStore(authenticationService: AuthenticationService.mock))
    }
}
