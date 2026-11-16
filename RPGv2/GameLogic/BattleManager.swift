//
//  BattleManager.swift
//  RPGMinecraft
//
//  Created by Thiago de Oliveira Sousa on 31/12/25.
//

import SwiftUI
import Combine

@MainActor
final class BattleManager: ObservableObject {
    
//    private var router: Router
    
    let player: Player
    let enemy: Player

    // Publicados para a UI reagir
    @Published var playerHealth: Int
    @Published var enemyHealth: Int
    @Published var playerStatusEffects: [any StatusEffect] = []
    @Published var enemyStatusEffects: [any StatusEffect] = []
    @Published var isPlayerTurn = true
    @Published var dialogText: String = ""

    @Published var dialogAction: ((String) async -> Void)?
    
    init(player: Player, enemy: Player) {
        self.player = player
        self.enemy = enemy
        self.playerHealth = player.health
        self.enemyHealth = enemy.health
    }

    // Sincroniza os @Published com o estado real dos Players
    private func syncState() {
        playerHealth = player.health
        enemyHealth = enemy.health
        playerStatusEffects = player.statusEffects
        enemyStatusEffects = enemy.statusEffects
    }

    func playerAttack(attackIndex: Int) {
        Task {
            let attack = player.character.attacks[attackIndex]

            player.character.attackPlayer(
                player: player,
                enemy: enemy,
                with: attack
            )

            attack.decraseAttacksRemaining(quantity: 1)
            syncState()

            logDebug("quantidade de ataques do \(attack.name): \(attack.remainingAttacks)")

            isPlayerTurn = false

            await dialogAction?(attack.attackDiolog)
            attack.setAttackdialog("")

            await sleep(seconds: 2)

            if checkIsEnd() {
                await endGame()
                return
            }

            startEnemyTurn()
        }
    }

    func startEnemyTurn() {
        Task {
            await self.enemy.processStatusEffects()
            syncState()

            if checkIsEnd() {
                await endGame()
                return
            }

            await sleep(seconds: 2)

            var attack = enemy.character.attacks.randomElement()!

            while attack.remainingAttacks <= 0 && enemy.hasAttack() {
                logDebug("trocando de ataque pois o selecionado não está habilitado")
                attack = enemy.character.attacks.randomElement()!
            }

            await self.dialogAction?("\(self.enemy.character.name) usou \(attack.name)")

            self.enemy.character.attackPlayer(
                player: self.enemy,
                enemy: self.player,
                with: attack
            )

            attack.decraseAttacksRemaining(quantity: 1)
            syncState()

            logDebug("quantidade de ataques do \(attack.name): \(attack.remainingAttacks)")

            if checkIsEnd() {
                await endGame()
                return
            }

            await sleep(seconds: 2)
            startPlayerTurn()
        }
    }

    func startPlayerTurn() {
        Task {
            await self.player.processStatusEffects()
            syncState()

            if checkIsEnd() {
                await endGame()
                return
            }

            self.isPlayerTurn = true
        }
    }

    func sleep(seconds: TimeInterval) async {
        try? await Task.sleep(
            nanoseconds: UInt64(seconds * 1_000_000_000)
        )
    }
}

// Resetar o game
extension BattleManager {
    func checkIsEnd() -> Bool {
        return player.health <= 0 || enemy.health <= 0
    }

    func endGame() async {
        await sleep(seconds: 3)

        isPlayerTurn = false

        if player.health <= 0 {
            print("Inimigo ganhou")
            await dialogAction?("\(enemy.character.name) ganhou!!")
        }

        if enemy.health <= 0 {
            print("Player ganhou")
            await dialogAction?("\(player.character.name) ganhou!!")
        }

        await sleep(seconds: 3)
        player.reset()
        enemy.reset()
        syncState()

        startPlayerTurn()
        
        // TODO: - Navegar para a tela de selecao
    }
}
