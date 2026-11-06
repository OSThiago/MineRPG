//
//  ContentView.swift
//  RPGv2
//
//  Created by Thiago de Oliveira Sousa on 19/07/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var router = Router()

    var body: some View {
        router.buildedView(scene: router.currentScene)
            .ignoresSafeArea()
            .environmentObject(router)
    }
}

#Preview {
    ContentView()
}

struct BattleView: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack {
            Text("Batalha")
            
            Button("Selecao") {
                router.navigate(to: .select)
            }
        }
    }
}
