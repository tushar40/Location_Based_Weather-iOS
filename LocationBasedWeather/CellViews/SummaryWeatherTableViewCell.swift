//
//  SummaryWeatherTableViewCell.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 06/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit

class SummaryWeatherTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet var summaryLabel: UILabel!
    
    //MARK:- Property Variables
    
    var summaryDescription: String! {
        didSet {
            summaryLabel.text = summaryDescription
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
