//
//  DailyWeatherTableViewCell.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 06/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var maxTemperatureLabel: UILabel!
    @IBOutlet var minTemperatureLabel: UILabel!
    
    //MARK:- Property Variables
    
    var date: String! {
        didSet {
            dateLabel.text = date
        }
    }
    var iconImage: UIImage! {
        didSet {
            iconImageView.image = iconImage
        }
    }
    var maxTemperature: Int! {
        didSet {
            maxTemperatureLabel.text = "\(String(describing: maxTemperature ?? 0))º"
        }
    }
    var mintemperature: Int! {
        didSet {
            minTemperatureLabel.text = "\(String(describing: mintemperature ?? 0))º"
        }
    }
    
    //MARK:- UITableViewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
