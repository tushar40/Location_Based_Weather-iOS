//
//  HourlyWeatherCondition.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation

struct HourlyWeatherCondition: Decodable {
    let time: Double
    let summary: String
    let icon: String
    let precipIntensity: Double
    let precipProbability: Double
    let precipType: String?
    let precipAccumulation: Double?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
}
