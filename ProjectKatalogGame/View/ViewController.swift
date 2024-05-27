//
//  ViewController.swift
//  ProjectKatalogGame
//
//  Created by I Putu Widiarta Nandana Githa on 05/05/24.
//

import UIKit

class ViewController: UIViewController {
    private var games : [Game] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.systemBlue;
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        Task {
            await getGames()
        }
    }
    
    
    func getGames() async {
      let network = NetworkService()
      do {
          games = try await network.getGame()
          tableView.reloadData()
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
    
    @IBAction func tapProfile(_ sender: Any) {
        performSegue(withIdentifier: "moveToProfile", sender: nil)
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GameTableViewCell {
            let game = games[indexPath.row]
            cell.gameName.text = game.name
            cell.imageGame.image = game.image
            cell.date.text = game.released
            cell.rating.text = String(game.rating)
            
            if game.state == .new {
                cell.loading.isHidden = false
                cell.loading.startAnimating()
                startDownload(game: game, indexPath: indexPath)
            } else {
              cell.loading.stopAnimating()
              cell.loading.isHidden = true
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    fileprivate func startDownload(game: Game, indexPath: IndexPath) {
      let imageDownloader = ImageDownloader()
      if game.state == .new {
        Task {
          do {
            let image = try await imageDownloader.downloadImage(url: game.imagePath)
            game.state = .downloaded
            game.image = image
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
          } catch {
            game.state = .failed
            game.image = nil
          }
        }
      }
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moveToDetail", sender: games[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail"{
            if let detailViewController = segue.destination as? DetailViewController{
                detailViewController.idGame = (sender as? Int)!
            }
        }
    }
}

