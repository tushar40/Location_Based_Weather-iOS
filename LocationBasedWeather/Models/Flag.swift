//
//  Flags.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation

struct Flag: Decodable {
    let sources: [String]
    let nearest_station: Double
    let units: String
}
