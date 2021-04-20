//
//  GameTableViewCell.swift
//  TestCase
//
//  Created by Mac on 18/04/2021.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblGameTitle: UILabel!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lblMetacriticScore: UILabel!
    @IBOutlet weak var lblGameGenere: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    var gameData: GameData? {
        didSet{
            guard let obj = gameData else {
                return
            }
            lblGameTitle.text = obj.name
            lblMetacriticScore.text = "\(obj.metacritic ?? 0)"
            
            let url = URL(string: obj.background_image ?? "google.com")!
            imgGame.kf.setImage(
                with: url,
                placeholder: UIImage.init(named: "noImage"),
                options: [
                    .cacheOriginalImage,
                    .transition(.fade(0.25))
                ],
                progressBlock: { receivedSize, totalSize in
                    // Progress updated
                },
                completionHandler: { result in
                    // Done
                }
            )
            lblGameGenere.text = obj.genre()
            viewContainer.backgroundColor = obj.backgroundColor()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
