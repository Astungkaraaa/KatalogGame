//
//  ImageDownloader.swift
//  ProjectKatalogGame
//
//  Created by I Putu Widiarta Nandana Githa on 05/05/24.
//

import Foundation
import UIKit

class ImageDownloader {
  func downloadImage(url: URL) async throws -> UIImage {
    async let imageData: Data = try Data(contentsOf: url)
    return UIImage(data: try await imageData)!
  }
}

