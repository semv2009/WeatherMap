//
//  ExtentionCollectionViewCell.swift
//  WeatherMap
//
//  Created by developer on 21.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class WeatherDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var namePropertyLabel: UILabel!
    @IBOutlet weak var valuePropertyLabel: UILabel!
   
    func updateUI(property: WeatherProperty) {
        namePropertyLabel.text = property.name
        valuePropertyLabel.text = property.value
        propertyImage.image = UIImage(imageLiteral: property.name.lowercaseString)
    }
}
