//
//  GameModel.swift
//  ProjectKatalogGame
//
//  Created by I Putu Widiarta Nandana Githa on 05/05/24.
//

import Foundation
import UIKit

enum DownloadState {
  case new, downloaded, failed
}

class Game{
    let id : Int
    let name : String
    let released : String
    let imagePath : URL
    let rating : Double
    let desc : String
    let genres : [Genre]
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(id: Int, name: String, released: String, imagePath: URL, rating: Double, desc: String, genres : [Genre]) {
        self.id = id
        self.name = name
        self.released = released
        self.imagePath = imagePath
        self.rating = rating
        self.desc = desc
        self.genres = genres
    }
}

struct GameResponses: Codable {
    let status: String
    let results: [GameResponse]
}

struct GameResponse: Codable {
    let id: Int
    let name, released: String?
    let backgroundImage: URL?
    let rating: Double?
    let descriptionRaw: String?
    let genres : [Genre]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case descriptionRaw = "description_raw"
        case genres
    }
}

struct Genre : Codable{
    let name : String
    let slug : String
}
