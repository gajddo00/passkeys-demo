//
//  EmojiItem.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation

struct EmojiItem: Hashable {
    var colorVariants: [String]
    var current: String
    
    init(_ colorVariants: [String]) {
        self.colorVariants = colorVariants
        // swiftlint:disable force_unwrapping
        self.current = colorVariants.first!
    }
    
    func isEqual(to item: EmojiItem) -> Bool {
        colorVariants == item.colorVariants
    }
}

extension EmojiItem {
    static let data: [EmojiItem] = [
        .init(["👩‍🦰", "👩🏻‍🦰", "👩🏼‍🦰", "👩🏽‍🦰", "👩🏾‍🦰", "👩🏿‍🦰"]),
        .init(["👨‍🦳", "👨🏻‍🦳", "👨🏼‍🦳", "👨🏽‍🦳", "👨🏾‍🦳", "👨🏿‍🦳"]),
        .init(["👧", "👧🏻", "👧🏼", "👧🏽", "👧🏾", "👧🏿"]),
        .init(["🧒", "🧒🏻", "🧒🏼", "🧒🏽", "🧒🏾", "🧒🏿"]),
        .init(["👦", "👦🏻", "👦🏼", "👦🏽", "👦🏾", "👦🏿"]),
        .init(["👩", "👩🏻", "👩🏼", "👩🏽", "👩🏾", "👩🏿"]),
        .init(["👩‍🦱", "👩🏻‍🦱", "👩🏼‍🦱", "👩🏽‍🦱", "👩🏾‍🦱", "👩🏿‍🦱"]),
        .init(["🧑‍🦱", "🧑🏻‍🦱", "🧑🏼‍🦱", "🧑🏽‍🦱", "🧑🏾‍🦱", "🧑🏿‍🦱"]),
        .init(["👱‍♀️", "👱🏻‍♀️", "👱🏼‍♀️", "👱🏽‍♀️", "👱🏾‍♀️", "👱🏿‍♀️"]),
        .init(["🧔‍♀️", "🧔🏻‍♀️", "🧔🏼‍♀️", "🧔🏽‍♀️", "🧔🏾‍♀️", "🧔🏿‍♀️"]),
        .init(["🧔‍♂️", "🧔🏻‍♂️", "🧔🏼‍♂️", "🧔🏽‍♂️", "🧔🏾‍♂️", "🧔🏿‍♂️"]),
        .init(["👳‍♀️", "👳🏻‍♀️", "👳🏼‍♀️", "👳🏽‍♀️", "👳🏾‍♀️", "👳🏿‍♀️"]),
        .init(["👵", "👵🏻", "👵🏼", "👵🏽", "👵🏾", "👵🏿"]),
        .init(["🤡"])
    ]
}
