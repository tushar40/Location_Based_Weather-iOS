//
//  CurrentWeather.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let time: Double
    let summary: String
    let icon: String
    let nearestStormDistance: Int?
    let nearestStormBearing: Int?
    let precipIntensity: Double
    let precipProbability: Double
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
    let visibility: Int
    let ozone: Double
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
