//
//  AuthenticationServicing.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation

protocol AuthenticationServicing {
    func singUpWith(username: String) async throws
}
