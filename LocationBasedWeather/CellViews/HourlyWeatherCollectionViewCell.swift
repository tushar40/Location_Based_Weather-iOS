//
//  HourlyWeatherCollectionViewCell.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 06/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    //MARK:- Property Variables
    var date: String! {
        didSet {
            dateLabel.text = date
        }
    }
    var image: UIImage! {
        didSet {
            iconImageView.image = image
        }
    }
    var temperature: Int! {
        didSet {
            temperatureLabel.text = "\(temperature ?? 0)ºC"
        }
    }
    
    //MARK:- UICollectionViewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
