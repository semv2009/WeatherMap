//
//  WeatherTempView.swift
//  WeatherMap
//
//  Created by developer on 29.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

@IBDesignable class WeatherTempView: UIView {
    
    var view: UIView!

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var nibName: String = "WeatherTempView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        if let view = nib.instantiateWithOwner(self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
    }
    
    func updateUI(weather: Weather) {
        if let temp = weather.temp {
            tempLabel.text = "\(temp)°C"
        }
        if let minTemp = weather.tempMin {
            minTempLabel.text = "Min = \(minTemp)°C"
        }
        if let maxTemp = weather.temMax {
            maxTempLabel.text = "Max = \(maxTemp)°C"
        }
        if let descriptions = weather.weatherDescription, description = descriptions[0].full {
            descriptionLabel.text = description
        }
        if let iconUrl = weather.iconUrl {
            descriptionImage.kf_setImageWithURL(iconUrl)
        }

    }
}
