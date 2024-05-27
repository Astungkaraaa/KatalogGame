//
//  Network Service.swift
//  ProjectKatalogGame
//
//  Created by I Putu Widiarta Nandana Githa on 05/05/24.
//

import Foundation

class NetworkService{
    
    func getGame() async throws -> [Game] {
        let components = URLComponents(string: "https://rawg-mirror.vercel.app/api/games")!
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw NetworkError.failedToFetchData(message: "Error: Can't fetching data. (network error)")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponses.self, from: data)
        
        return gameMapper(input: result.results)
    }
    
    func getDetailGame(idGame : Int) async throws -> Game{
        let components = URLComponents(string: "https://rawg-mirror.vercel.app/api/games/\(idGame)")!
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw NetworkError.failedToFetchData(message: "Error: Can't fetching data. (network error)")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponse.self, from: data)
        
        return Game(
            id: result.id, name: result.name ?? "", released: result.released ?? "", imagePath: (result.backgroundImage ?? URL(string: ""))!, rating: result.rating ?? 0.0, desc: result.descriptionRaw ?? "", genres: result.genres
        )
    }
    
}

extension NetworkService {
    fileprivate func gameMapper(
        input gameResponses: [GameResponse]
    ) -> [Game] {
        return gameResponses.map { result in
            return Game(
                id: result.id, name: result.name ?? "", released: result.released ?? "", imagePath: (result.backgroundImage ?? URL(string: ""))!, rating: result.rating ?? 0.0, desc: result.descriptionRaw ?? "", genres: result.genres
            )
        }
    }
}

enum NetworkError: Error {
    case failedToFetchData(message: String)
}


