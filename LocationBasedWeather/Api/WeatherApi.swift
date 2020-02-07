//
//  WeatherApi.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation
import GoogleMaps

enum Exclude: String {
    case minutely = "minutely"
    case flags = "flags"
    case alerts = "alerts"
    case daily = "daily"
}

class WeatherApi {
    
    //MARK:- Property Variables
    
    private static let baseUrl = "https://api.darksky.net/"
    private static let endPoint = "forecast/"
    private static let apiKey = Constants.WeatherApiKey
    
    private let exclude: [Exclude] = [.minutely, .flags, .alerts]
    private let calendar = Calendar.current
    private var apiUrlString: String = {
        let urlString = "\(baseUrl)\(endPoint)\(apiKey)/"
        return urlString
    }()
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter
    }()
    private let weekday = [
                        1: "Sunday",
                        2: "Monday",
                        3: "Tuesday",
                        4: "Wednesday",
                        5: "Thrusday",
                        6: "Friday",
                        7: "Saturday"
    ]
    
    static let shared = WeatherApi()
    
    //MARK:- Initializers
    
    private init() { }
    
    //MARK:- Member Functions
    
    func forecast(coordinates: CLLocationCoordinate2D, excludeItems: [Exclude]? = nil, time: Date? = nil, completion: @escaping (Result<WeatherData,Error>) -> Void) {
        var urlString = "\(apiUrlString)\(coordinates.latitude),\(coordinates.longitude)"
        if let time = time {
            let formattedTime = time
            urlString = "\(urlString),\(formattedTime)"
        }
        
        var excludeTerms = exclude
        if let excludeItems = excludeItems {
            excludeTerms = excludeItems
        }
        var exculdeString = "\(excludeTerms[0])"
        if excludeTerms.count > 1 {
            for index in 1..<excludeTerms.count {
                exculdeString = "\(exculdeString),\(excludeTerms[index])"
            }
        }
        urlString = "\(urlString)?exclude=\(exculdeString)"
        
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(String(describing: error))
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    completion(.failure(error))
                }
            } else {
                print("nil Data returned")
            }
        }
        task.resume()
    }
    
    func convertToDateString(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func convertToDay(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let day: Int = calendar.component(.weekday, from: date)
        return weekday[day]!
    }
    
    func convertToTimeString(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formattedTime = timeFormatter.string(from: date)
        return formattedTime
    }
    
    func convertToCelcius(tempInFarenheit: Double) -> Int {
        return Int((tempInFarenheit - 32) * 5/9)
    }
}
