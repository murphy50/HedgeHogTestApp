//
//  CustomCollectionViewCell.swift
//  HedgehogTestApp
//
//  Created by murphy on 07.02.2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    @IBOutlet weak var image: UIImageView!
    

        
    func setup(with image: UIImage) {
        self.image.image = image
        self.image.layer.shadowColor = UIColor.darkGray.cgColor
        
        self.image.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.image.layer.shadowOpacity = 0.8
        self.image.layer.shadowRadius = 2
        
    }
}
