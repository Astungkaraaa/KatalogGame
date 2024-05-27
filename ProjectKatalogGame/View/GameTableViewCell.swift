//
//  MovieTableViewCell.swift
//  ProjectKatalogGame
//
//  Created by I Putu Widiarta Nandana Githa on 05/05/24.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
