//
//  ViewController.swift
//  WeatherByJana
//
//  Created by Jana Beth Hart on 6/18/19.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var appName: UILabel!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var currentConditionsView: UIView!
    @IBOutlet var location: UILabel!
    @IBOutlet var degrees: UILabel!
    @IBOutlet var feelsLike: UILabel!
    @IBOutlet var conditionIcon: UIImageView!
    @IBOutlet var condition: UILabel!
    @IBOutlet var forecastTableView: UITableView!
    
    let dataManager = DataManager()
    var selectedRowIndex = -1
    let locationManager = CLLocationManager()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: DataManager.NewDataArrivedNotificationName), object: nil, queue: OperationQueue.main)
        { (notification) in
            self.forecastTableView.reloadData()
            self.updateCurrentConditions()
        }
        
        //dataManager = DataManager()
        dataManager.getWeather()
        dataManager.getForecast()
    }

    func updateCurrentConditions()
    {
        if let lat = dataManager.dailyForecast?.city.coordinate.latitude, let lon = dataManager.dailyForecast?.city.coordinate.longitude
        {
            let myLoc = CLLocation.init(latitude: lat, longitude: lon)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(myLoc) {
                (places: [CLPlacemark]?, error: Error?) in
                guard let places = places else
                {
                    return
                }
                if let place = places.first
                {
                    let city = place.locality ?? ""
                    let state = place.administrativeArea ?? ""
                    self.location.text = city.capitalized + ", " + state.uppercased()
                }
            }
        }
        
        guard let mainWeather = dataManager.currentWeather?.main else
        {
            return
        }
        
        degrees.text = DataManager.printableTemp(temp: mainWeather.temperature)
        condition.text = dataManager.currentWeather?.weather.first?.main.capitalized
        feelsLike.text = "Feels like " + DataManager.printableTemp(temp: mainWeather.temperature)
        
        if let iconName = dataManager.currentWeather?.weather.first?.icon
        {
            let wc = WeatherConditionFromWeatherIconName(iconName)
            let images = wc.icon
            conditionIcon.image = images.0
        }
        
        DispatchQueue.main.async {
            self.currentConditionsView.setNeedsDisplay()
        }
    }
    
    // MARK - Table View Delegate
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == selectedRowIndex
        {
            return 120 //Expanded
        }
        
        return 66 //Not expanded
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let forecast = dataManager.dailyForecast else
        {
            return 0
        }
        
        return forecast.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier) as! DailyForecastTableViewCell

        if let forecast = dataManager.dailyForecast
        {
            let model = forecast.list[indexPath.row]
            cell.assignValuesFromModel(model, index: indexPath.row)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedRowIndex == indexPath.row
        {
            selectedRowIndex = -1
        }
        else
        {
            selectedRowIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}

