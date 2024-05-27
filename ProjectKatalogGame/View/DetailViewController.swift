//
//  DetailViewController.swift
//  ProjectKatalogGame
//
//  Created by I Putu Widiarta Nandana Githa on 11/05/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var ketGenre: UILabel!
    @IBOutlet weak var ketReleaseDate: UILabel!
    @IBOutlet weak var ketRatin: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var namaGame: UILabel!
    @IBOutlet weak var desc: UILabel!
    var idGame : Int = 0
    var game : Game? = nil
    
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    @IBOutlet weak var loadingKonten: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        roundedView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        rating.isHidden = true
        genre.isHidden = true
        releaseDate.isHidden = true
        desc.isHidden = true
        namaGame.isHidden = true
        ketGenre.isHidden = true
        ketReleaseDate.isHidden = true
        ketRatin.isHidden = true
        
        loadingImage.startAnimating()
        loadingKonten.startAnimating()
        
        Task{
            await getDetailGames()
            downloadImage(game: game)
            
            DispatchQueue.main.async {
                self.loadingKonten.stopAnimating()
                self.loadingKonten.isHidden = true
                
                self.rating.isHidden = false
                self.genre.isHidden = false
                self.releaseDate.isHidden = false
                self.desc.isHidden = false
                self.namaGame.isHidden = false
                self.ketGenre.isHidden = false
                self.ketReleaseDate.isHidden = false
                self.ketRatin.isHidden = false
                
                self.namaGame.text = self.game?.name
                self.releaseDate.text = self.game?.released
                self.rating.text = String(self.game?.rating ?? 0.0)
                self.desc.text = self.game?.desc
                self.genre.text = self.game?.genres.map { $0.name }.joined(separator: ", ")
            }
        }
        
    }
    
    
    func getDetailGames() async {
      let network = NetworkService()
      do {
        game = try await network.getDetailGame(idGame: idGame)
      } catch let error as NetworkError {
          let errorMessage = error.localizedDescription
          presentAlert(message: errorMessage)
      } catch {
          let errorMessage = "Failed to fetch games. Please try again later."
          presentAlert(message: errorMessage)
      }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func downloadImage(game: Game?) {
      let imageDownloader = ImageDownloader()
        Task {
          do {
              let image = try await imageDownloader.downloadImage(url: game!.imagePath)
              DispatchQueue.main.async {
                  self.loadingImage.stopAnimating()
                  self.loadingImage.isHidden = true
                  self.imgGame.image = image
              }
          } catch {
              let errorMessage = "Error: cannot download image"
              presentAlert(message: errorMessage)
          }
        }
    }
    

}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
