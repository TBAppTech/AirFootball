//
//  TeamCell.swift
//  AirFootBall
//
//  Created by Roma Bogatchuk on 20.02.2023.
//

import UIKit

class TeamCell: UICollectionViewCell {

    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var playerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static let identifier = "teamCell"
    static func nib () -> UINib {
        return UINib(nibName: "TeamCell", bundle: nil)
    }

}
