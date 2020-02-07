//
//  WeatherData.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather?
    let flags: Flag?
    let offset: Double
}
