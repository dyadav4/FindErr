//
//  HomeTableViewCell.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none
        selectedBackgroundView?.isHidden = true

    }
    
    var shops: Store! {
        didSet {
            self.updateCellUI()
        }
    }
    
    func updateCellUI(){
        storeNameLabel.text = shops.name
        self.storeImageView.image = nil
        self.storeImageView.loadImage(url: shops.image)
    }
    
}
