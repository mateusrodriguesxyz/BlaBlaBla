//
//  SwiftUIView.swift
//  BlaBlaBla
//
//  Created by Mateus Rodrigues on 18/11/23.
//

import SwiftUI

struct CharactersResponse: Codable {
    let results: [Character]
}

struct Character: Identifiable, Codable {
    let id: Int
    let name: String
    let created: String
}

struct SwiftUIView: View {
    
    @State var characters: [Character] = []
    
    let url = URL(string: "https://rickandmortyapi.com/api/character")!
    
    var body: some View {
        List {
            ForEach(characters) {
                CharacterView(character: $0)
            }
        }
        .task {
            
            do {
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(CharactersResponse.self, from: data)
                self.characters = response.results
            } catch {
                
            }
            
        }
    }
}

struct CharacterView: View {
    
    @State private var isLoadingAvatar: Bool = false
    @State private var avatar: UIImage?
    
    let character: Character
    
    var body: some View {
        HStack {
            Text(character.name)
            Spacer()
            if let avatar {
                Image(uiImage: avatar)
                    .resizable()
                    .scaledToFit()
            } else {
                if isLoadingAvatar {
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            Task {
                                await CharacterImageLoader.shared.cancel(for: character.id)
                            }
                        }
                }
            }
        }
        .frame(height: 50)
        .task {
            isLoadingAvatar = true
            avatar = await CharacterImageLoader.shared.value(for: character.id, caching: .disabled)
            isLoadingAvatar = false
        }
    }
}

#Preview {
    SwiftUIView()
}
