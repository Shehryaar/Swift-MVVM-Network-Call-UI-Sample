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
    
    var gameData: GameData? {
        didSet{
            guard let obj = gameData else {
                return
            }
            lblGameTitle.text = obj.name
            lblMetacriticScore.text = "\(obj.metacritic)"
            
            let url = URL(string: obj.background_image ?? "")

            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async { [unowned self] in
                    imgGame.image = UIImage(data: data!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
