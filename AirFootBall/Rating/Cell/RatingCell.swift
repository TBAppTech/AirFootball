//
//  RatingCell.swift
//  AirFootBall
//
//  Created by Roma Bogatchuk on 22.02.2023.
//

import UIKit

class RatingCell: UITableViewCell {

    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var goldLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
        playerLabel.textColor = .white
        goldLabel.textColor = .white
        self.backgroundColor = .clear
        backgroundViewCell.layer.cornerRadius = 10

    }
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static let identifier = "ratingCell"
    static func nib () -> UINib {
        return UINib(nibName: "RatingCell", bundle: nil)
    }
}
