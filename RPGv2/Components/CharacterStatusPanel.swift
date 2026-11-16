//
//  CharacterStatusPanel.swift
//  RPGv2
//

import SwiftUI

struct CharacterStatusPanel: View {

    // MARK: - Properties
    let characterName: String
    let maxHealth: Int
    let currentHealth: Int
    let statusEffects: [any StatusEffect]

    private let barWidth: CGFloat
    private let barHeight: CGFloat

    // MARK: - Init
    init(
        characterName: String,
        maxHealth: Int,
        currentHealth: Int,
        statusEffects: [any StatusEffect] = [],
        width: CGFloat = 200,
        barHeight: CGFloat = 14
    ) {
        self.characterName = characterName
        self.maxHealth = maxHealth
        self.currentHealth = max(0, min(currentHealth, maxHealth))
        self.statusEffects = statusEffects
        self.barWidth = width
        self.barHeight = barHeight
    }

    // MARK: - Computed
    private var healthPercentage: CGFloat {
        guard maxHealth > 0 else { return 0 }
        return CGFloat(currentHealth) / CGFloat(maxHealth)
    }

    private var barColor: Color {
        switch healthPercentage {
        case 0.6...1.0: return .green
        case 0.3..<0.6: return .yellow
        default:        return .red
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            nameRow
            hpBar
            hpText
            statusEffectsRow
        }
        .frame(width: barWidth)
    }

    // MARK: - Subviews

    private var nameRow: some View {
        Text(characterName.uppercased())
            .font(.custom("Minecraft", size: 14))
            .foregroundColor(.white)
    }

    private var hpBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color(uiColor: .darkGray))
                    .frame(height: barHeight)
                    .cornerRadius(2)

                // Foreground (HP)
                Rectangle()
                    .fill(barColor)
                    .frame(
                        width: geo.size.width * healthPercentage,
                        height: barHeight
                    )
                    .cornerRadius(2)
                    .animation(.easeInOut(duration: 0.15), value: healthPercentage)

                // Border
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(height: barHeight)
            }
        }
        .frame(height: barHeight)
    }

    private var hpText: some View {
        HStack {
            Spacer()
            Text("HP \(currentHealth) / \(maxHealth)")
                .font(.custom("Minecraft", size: 10))
                .foregroundColor(.white)
        }
    }

    private var statusEffectsRow: some View {
        HStack(spacing: 8) {
            ForEach(statusEffectsFlattened, id: \.id) { item in
                Image(item.textureName)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }

    /// Expande cada StatusEffect em N ícones (um por turno restante), igual ao SpriteKit original
    private var statusEffectsFlattened: [StatusEffectItem] {
        var items: [StatusEffectItem] = []
        for effect in statusEffects {
            for i in 0..<effect.remainingTurns {
                items.append(StatusEffectItem(
                    id: "\(effect.textureName)-\(i)",
                    textureName: effect.textureName
                ))
            }
        }
        return items
    }
}

// MARK: - Helper
private struct StatusEffectItem: Identifiable {
    let id: String
    let textureName: String
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        CharacterStatusPanel(
            characterName: "Steve",
            maxHealth: 100,
            currentHealth: 45
        )
        .padding()
    }
}
