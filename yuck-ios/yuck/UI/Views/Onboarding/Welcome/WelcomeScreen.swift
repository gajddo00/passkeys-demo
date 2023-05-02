//
//  WelcomeScreen.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import SwiftUI
import Combine
import SFSafeSymbols

struct WelcomeScreen: View {
    @StateObject private var store: WelcomeStore
    
    init(store: WelcomeStore) {
        self._store = StateObject(wrappedValue: store)
    }
}

// MARK: - Body
extension WelcomeScreen {
    var body: some View {
        ZStack(alignment: .center) {
            Image(RImage.welcomeBackground.name)
            
            content()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Components
private extension WelcomeScreen {
    @ViewBuilder func content() -> some View {
        VStack {
            Spacer()
            
            Button {
                store.send(action: .didTapWelcome)
            } label: {
                HStack(alignment: .center) {
                    Text(RString.welcomeTitle())
                        .font(.title2)
                    
                    Image(systemSymbol: .chevronRight)
                        .font(.body)
                        .offset(y: 1.5)
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
            .foregroundColor(.black)
            .background(.white)
        }
    }
}

// MARK: - Preview
struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(store: WelcomeStore())
    }
}
