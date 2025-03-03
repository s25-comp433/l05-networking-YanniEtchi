//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Game]
}

struct Game: Codable {
    var date: String
    var id: Int
    var opponent: String
    var team: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games: [Game] = []

    var body: some View {
        NavigationStack {
            List(games, id: \.id) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)

                        Spacer()

                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)
                    }

                    HStack {
                        Text(game.date)
                            .font(.caption)

                        Spacer()

                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("UNC Basketball")
            .task {
                await loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball")
        else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(
                [Game].self, from: data)
            {
                games = decodedResponse
            }
        } catch {
            print("Failed to fetch datass")
        }
    }
}

#Preview {
    ContentView()
}
