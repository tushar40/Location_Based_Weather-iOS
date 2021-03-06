//
//  DailyWeather.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation

struct DailyWeather: Decodable {
    let summary: String
    let icon: String
    let data: [DailyWeatherCondition]?
}
