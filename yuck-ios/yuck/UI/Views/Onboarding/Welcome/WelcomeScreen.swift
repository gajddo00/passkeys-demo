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
            Color.grayColor
                .ignoresSafeArea()
            
            Image(RImage.appIcon.name)
                .resizable()
                .scaledToFit()
            
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
                Text(RString.welcomeTitle())
            }
            .primaryButtonWhite()
        }
    }
}

// MARK: - Preview
struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen(store: WelcomeStore())
    }
}
