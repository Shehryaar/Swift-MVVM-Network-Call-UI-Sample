//
//  GameCollectionViewCell.swift
//  TestCase
//
//  Created by Mac on 15/04/2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblGameTitle: UILabel!
    @IBOutlet weak var imgGame: UIImageView!
    @IBOutlet weak var lblMetacriticScore: UILabel!
    @IBOutlet weak var lblGameGenere: UILabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    var gameData: GameModel? {
        didSet{
            guard let obj = gameData else {
                return
            }
            // TODO:- run timer according to backend data
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
