//
//  GameSession.swift
//  RPGv2
//

import SwiftUI
import Combine

final class GameSession: ObservableObject {
    @Published var selectedPlayer: Character?
    @Published var selectedEnemy: Character?
}
