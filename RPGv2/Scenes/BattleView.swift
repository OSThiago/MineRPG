//
//  BattleView.swift
//  RPGv2
//
//  Created by Thiago de Oliveira Sousa on 06/11/26.
//

import SwiftUI

struct BattleView: View {
    
    @EnvironmentObject var router: Router

    @StateObject private var battleManager: BattleManager
    @ObservedObject private var dialogController = DialogController.shared
    @EnvironmentObject var gameSession: GameSession

    init(player: Character, enemy: Character) {
        _battleManager = StateObject(wrappedValue: BattleManager(
            player: Player(character: player),
            enemy: Player(character: enemy)
        ))
    }
    
    var body: some View {
        VStack {
            Text("Batalha")
            
            VStack {
                HStack {
                    // Painel do inimigo
                    VStack {
                        CharacterStatusPanel(
                            characterName: battleManager.enemy.character.name,
                            maxHealth: battleManager.enemy.character.health,
                            currentHealth: battleManager.enemyHealth,
                            statusEffects: battleManager.enemyStatusEffects
                        )
                        
                        Image(battleManager.enemy.spriteName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }

                    Spacer()
                }
                
                Spacer()
                    .frame(maxHeight: 200)
                
                HStack {
                    Spacer()
                    // Painel do player
                    VStack {
                        CharacterStatusPanel(
                            characterName: battleManager.player.character.name,
                            maxHealth: battleManager.player.character.health,
                            currentHealth: battleManager.playerHealth,
                            statusEffects: battleManager.playerStatusEffects
                        )
                        
                        Image(battleManager.player.spriteName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)

                    }
                }
            }
            
            Spacer()

            // Caixa de diálogo — aparece automaticamente quando o BattleManager envia mensagens
            DialogBoxView(controller: dialogController)

            // Botões de ataque 2x2
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(battleManager.player.character.attacks.indices, id: \.self) { i in
                    Button(battleManager.player.character.attacks[i].name) {
                        battleManager.playerAttack(attackIndex: i)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .disabled(!battleManager.isPlayerTurn)
                }
            }
            Spacer()
        }
        .safeAreaPadding(.all)
        .padding(.vertical, 32)
        .background(Color.black)
        .onAppear {
            battleManager.battleProtocol = self
            // Conecta o BattleManager ao DialogController compartilhado.
            // O manager apenas chama essa closure e aguarda — sem saber nada de UI.
            battleManager.dialogAction = { text in
                await DialogController.shared.show(text)
            }
        }
    }
}

extension BattleView: BattleManagerProtocol {
    func battleDidEnd() {
        router.navigate(to: .select)
    }
}

#Preview {
    BattleView(player: Steve(), enemy: Zombie())
        .environmentObject(Router())
}
