//
//  DailyWeatherCondition.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation

struct DailyWeatherCondition: Decodable {
    let time: Double
    let summary: String
    let icon: String
    let sunriseTime: Double
    let sunsetTime: Double
    let moonPhase: Double
    let precipIntensity: Double
    let precipIntensityMax: Double
    let precipIntensityMaxTime: Double
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Double
    let temperatureLow: Double
    let temperatureLowTime: Double
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Double
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Double
    let windBearing: Double
    let cloudCover: Double
    let uvIndex: Int
    let uvIndexTime: Double
    let visibility: Double
    let ozone: Double
    let temperatureMin: Double
    let temperatureMinTime: Double
    let temperatureMax: Double
    let temperatureMaxTime: Double
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Double
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Double
}
