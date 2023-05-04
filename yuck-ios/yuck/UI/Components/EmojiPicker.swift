//
//  EmojiPicker.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import SwiftUI

struct EmojiPicker: View {
    let items: [EmojiItem]
    @Binding var pickedEmoji: String
        
    @State private var selectedEmojiItem: EmojiItem
    @State private var colorVariationsDisplayed = false
        
    init(items: [EmojiItem], pickedEmoji: Binding<String>) {
        self.items = items
        self._pickedEmoji = pickedEmoji
        selectedEmojiItem = items.first ?? .init([])
    }
    
    var body: some View {
        VStack(spacing: 10) {
            content()
            
            if colorVariationsDisplayed {
                variants(for: selectedEmojiItem)
            }
        }
        .onTapGesture {
            if colorVariationsDisplayed {
                withAnimation {
                    colorVariationsDisplayed = false
                }
            }
        }
        .onChange(of: selectedEmojiItem) { newValue in
            pickedEmoji = newValue.current
        }
    }
}

// MARK: Components
private extension EmojiPicker {
    @ViewBuilder func content() -> some View {
        FittedScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 80))], spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Group {
                        if selectedEmojiItem.current == item.current {
                            Text(item.current)
                                .padding(10)
                                .background(Color.grayColor)
                                .cornerRadius(12)

                        } else if selectedEmojiItem.isEqual(to: item) {
                            Text(selectedEmojiItem.current)
                                .padding(10)
                                .background(Color.grayColor)
                                .cornerRadius(12)
                        } else {
                            Text(item.current)
                                .padding(10)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedEmojiItem = item
                            colorVariationsDisplayed = false
                        }
                    }
                    .onLongPressGesture(minimumDuration: 0) {
                        withAnimation {
                            selectedEmojiItem = item
                            colorVariationsDisplayed = true
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.lightGrayColor)
        .cornerRadius(12)
    }
    
    @ViewBuilder func variants(for item: EmojiItem) -> some View {
        HStack {
            ForEach(item.colorVariants, id: \.self) { emoji in
                Group {
                    if selectedEmojiItem.current == emoji {
                        Text(emoji)
                            .padding(10)
                            .background(Color.grayColor)
                            .cornerRadius(12)

                    } else {
                        Text(emoji)
                            .padding(10)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        selectedEmojiItem.current = emoji
                        colorVariationsDisplayed = false
                    }
                }
            }
        }
        .background(Color.lightGrayColor)
        .cornerRadius(12)
    }
}

// MARK: Preview
struct EmojiPicker_Previews: PreviewProvider {
    static var previews: some View {
        EmojiPicker(items: [], pickedEmoji: .constant(""))
    }
}
