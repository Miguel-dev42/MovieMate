//
//  MovieTableViewCell.swift
//  GroupProjectApp
//
//  Created by Miguel Figueroa on 1/23/20.
//  Copyright © 2020 Miguel Figueroa. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    override func prepareForReuse() {
        movieImage.image = UIImage(named: "loading")
    }
}
