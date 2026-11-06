//
//  SelectionView.swift
//  RPGMinecraft
//
//  Created by Thiago de Oliveira Sousa on 23/03/26.
//

import SwiftUI

struct SelectionView: View {
    
    @EnvironmentObject var router: Router
    
    let characters: [Character] = [Enderman(),
                                   Steve(),
                                   Witch(),
                                   Zombie()]
    
    @State var selectedCharacter: Character?
    @State var selectedEnemy: Character?
    
    
    var body: some View {
        VStack {
            HStack {
                charactersListView(selection: $selectedCharacter)
                
                Spacer()
                
                charactersListView(selection: $selectedEnemy)
            }
            .padding()
            
            Spacer()
            
                Button {
                    router.navigate(to: .battle)
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 200, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Text("Play")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                }


        }
    }
}

extension SelectionView {
    func charactersListView(selection: Binding<Character?>) -> some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack{
                Text("Selected:")
                Text(selection.wrappedValue?.name ?? "")
                    .foregroundStyle(.green)
                    .bold()
            }
            
            ForEach(characters, id: \.name) { character in
                characterButton(character, selection: selection)
            }
        }
    }
    
    func characterButton(_ character: Character, selection:  Binding<Character?>) -> some View {
        Button {
            print("selecionado: \(character)")
            if selection.wrappedValue?.name == character.name {
                selection.wrappedValue = nil
            } else {
                selection.wrappedValue = character
            }
        } label: {
            VStack(alignment: .center, spacing: 8) {
                Image(character.spriteName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                Text(character.name)
            }
        }
    }
}

#Preview {
    // Preview precisa de um UIViewController mock para o AppRouter
    SelectionView()
}
