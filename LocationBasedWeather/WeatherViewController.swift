//
//  WeatherViewController.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 05/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit.MKPlacemark

class WeatherViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var currentTemperatureLabel: UILabel!
    @IBOutlet var todayDateLabel: UILabel!
    @IBOutlet var hourlyWeatherCollectionView: UICollectionView! {
        didSet {
            hourlyWeatherCollectionView.delegate = self
            hourlyWeatherCollectionView.dataSource = self
        }
    }
    @IBOutlet var dailyWeatherTableView: UITableView! {
        didSet {
            dailyWeatherTableView.delegate = self
            dailyWeatherTableView.dataSource = self
        }
    }
    
    //MARK:- Property Variables
    
    private let weatherApi = WeatherApi.shared
    private var currentWeatherdata: WeatherData?
    private var hourlyWeatherList = [HourlyWeatherCondition]()
    private var dailyWeatherList = [DailyWeatherCondition]()
    private var currentWeatherDataList = [(String, Any)]()
    
    private let hourlyWeatherCellIdentifier = "HourlyWeatherCollectionViewCell"
    private let dailyWeatherCellIdentifier = "DailyWeatherTableViewCell"
    private let summaryWeatherCellIdentifier = "SummaryWeatherTableViewCell"
    private let weatherDataCellIdentifier = "WeatherDataTableViewCell"
    
    private var coordinates: CLLocationCoordinate2D!
    var placemark: MKPlacemark!
    
    //MARK:- Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        coordinates = placemark.coordinate
        
        weatherApi.forecast(coordinates: coordinates) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weather):
                self.currentWeatherdata = weather
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(let error):
                print("Error getting weather data: ",error)
                self.currentWeatherdata = nil
            }
        }
    }
    
    //MARK:- Custom Methods
    
    private func registerCells() {
        hourlyWeatherCollectionView.register(UINib(nibName: hourlyWeatherCellIdentifier, bundle: nil), forCellWithReuseIdentifier: hourlyWeatherCellIdentifier)
        dailyWeatherTableView.register(UINib(nibName: dailyWeatherCellIdentifier, bundle: nil), forCellReuseIdentifier: dailyWeatherCellIdentifier)
        dailyWeatherTableView.register(UINib(nibName: summaryWeatherCellIdentifier, bundle: nil), forCellReuseIdentifier: summaryWeatherCellIdentifier)
        dailyWeatherTableView.register(UINib(nibName: weatherDataCellIdentifier, bundle: nil), forCellReuseIdentifier: weatherDataCellIdentifier)
    }

    private func updateUI() {
        if let currentWeatherData = currentWeatherdata {
            placeLabel.text = placemark.title
            weatherDescriptionLabel.text = currentWeatherData.hourly.summary
            let tempInCelcius = weatherApi.convertToCelcius(tempInFarenheit: currentWeatherData.currently.temperature)
            currentTemperatureLabel.text = "\(String(describing: tempInCelcius))ºC"
            todayDateLabel.text = weatherApi.convertToDateString(timestamp: currentWeatherData.currently.time)
            hourlyWeatherList = currentWeatherData.hourly.data
            dailyWeatherList = currentWeatherData.daily?.data ?? []
            let currentWeatherDictionary = currentWeatherData.currently.dictionary
            for (key,value) in currentWeatherDictionary {
                currentWeatherDataList.append((key,value))
            }
        } else {
            placeLabel.text = nil
            weatherDescriptionLabel.text = nil
            currentTemperatureLabel.text = nil
            todayDateLabel.text = nil
            hourlyWeatherList = []
            dailyWeatherList = []
            currentWeatherDataList = []
        }
        
        hourlyWeatherCollectionView.reloadData()
        dailyWeatherTableView.reloadData()
    }
}

//MARK:- UICollectionView Delegate Methods

extension WeatherViewController: UICollectionViewDelegate {
    
}

//MARK:- UICollectionView Data Source Methods
extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Int(hourlyWeatherList.count / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyWeatherCellIdentifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        
        let weatherData = hourlyWeatherList[indexPath.row]
        hourlyCell.date = weatherApi.convertToTimeString(timestamp: weatherData.time)
        hourlyCell.image = UIImage(named: weatherData.icon)
        let temperatureInCelcius = weatherApi.convertToCelcius(tempInFarenheit: weatherData.temperature)
        hourlyCell.temperature = temperatureInCelcius
        
        return hourlyCell
    }
}

//MARK:- UITableView Delegate Methods

extension WeatherViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let hidden = scrollView.contentOffset.y != scrollView.contentInset.top
        currentTemperatureLabel.isHidden = hidden
        todayDateLabel.isHidden = hidden
    }
}

//MARK:- UITableView Delegate Methods

extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyWeatherList.count
        } else if section == 1 {
            return 1
        } else {
            return Int(currentWeatherDataList.count / 2)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let dailyWeatherCell = tableView.dequeueReusableCell(withIdentifier: dailyWeatherCellIdentifier, for: indexPath) as! DailyWeatherTableViewCell
            
            let dailyWeatherCondition = dailyWeatherList[row]
            dailyWeatherCell.date = weatherApi.convertToDay(timestamp: dailyWeatherCondition.time)
            dailyWeatherCell.iconImage = UIImage(named: dailyWeatherCondition.icon)
            dailyWeatherCell.maxTemperature = weatherApi.convertToCelcius(tempInFarenheit: dailyWeatherCondition.temperatureMax)
            dailyWeatherCell.mintemperature = weatherApi.convertToCelcius(tempInFarenheit: dailyWeatherCondition.temperatureMin)
            
            return dailyWeatherCell
        } else if section == 1 {
            let summaryWeatherCell = tableView.dequeueReusableCell(withIdentifier: summaryWeatherCellIdentifier, for: indexPath) as! SummaryWeatherTableViewCell
            
            summaryWeatherCell.summaryDescription = currentWeatherdata?.daily?.summary
            
            return summaryWeatherCell
        } else {
            let weatherDataCell = tableView.dequeueReusableCell(withIdentifier: weatherDataCellIdentifier, for: indexPath) as! WeatherDataTableViewCell
            
            let weatherData = [currentWeatherDataList[2 * row], currentWeatherDataList[2 * row + 1]]
            weatherDataCell.leftKeyName = weatherData[0].0
            weatherDataCell.leftValueName = String(describing: weatherData[0].1)
            weatherDataCell.rightKeyName = weatherData[1].0
            weatherDataCell.rightValueName = String(describing: weatherData[1].1)
            
            return weatherDataCell
        }
    }
}
