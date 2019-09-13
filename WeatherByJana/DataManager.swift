//
//  DataManager.swift
//  WeatherByJana
//
//  Created by Jana Beth Hart on 6/19/19.
//

import Foundation
import Weathersama

class UserPreferences: NSObject
{
    let cityKey = "city"
    let unitKey = "unit"
    
    enum TempUnits: String
    {
        case Fahrenheit = "Fahrenheit"
        case Celsius = "Celsius"
    }
    
    var cityName = "Atlanta"
    var units = TempUnits.Fahrenheit
    
    init(name: String, unit: TempUnits)
    {
        cityName = name
        units = unit
    }
    
    override init()
    {
        super.init()
        self.readFromPrefs()
    }
    
    func readFromPrefs()
    {
        if let city = UserDefaults.standard.string(forKey: cityKey)
        {
            cityName = city
        }
        
        if let unit = UserDefaults.standard.string(forKey: unitKey), let tempUnit = TempUnits.init(rawValue: unit)
        {
            units = tempUnit
        }
    }
    
    func saveToPrefs()
    {
        UserDefaults.standard.setValue(cityName, forKey: cityKey)
        UserDefaults.standard.setValue(units.rawValue, forKey: unitKey)
    }
}

class DataManager: NSObject
{
    let OpenWeatherAppID = "3aa158b2f14a9f493a8c725f8133d704"
    static let NewDataArrivedNotificationName = "NewDataArrived"
    
    var weatherSama: Weathersama!
    var dailyForecast: DailyForecastModel?
    var currentWeather: WeatherModel?
    
    var temperatureUnits: TEMPERATURE_TYPES = TEMPERATURE_TYPES.Fahrenheit
    var language: LANGUAGES = LANGUAGES.English
    let dataResponse: DATA_RESPONSE = DATA_RESPONSE.JSON
    
    var userPrefs: UserPreferences?
    
    override init()
    {
        super.init()
        updateFromPrefs(UserPreferences())
    }
    
    func updateFromPrefs(_ newPrefs: UserPreferences)
    {
        userPrefs = newPrefs
        if newPrefs.units == UserPreferences.TempUnits.Fahrenheit
        {
            temperatureUnits = TEMPERATURE_TYPES.Fahrenheit
        }
        else
        {
            temperatureUnits = TEMPERATURE_TYPES.Celcius
        }
        
        weatherSama = Weathersama(appId: OpenWeatherAppID, temperature: temperatureUnits, language: language, dataResponse: dataResponse)
    }
    
    func getWeather()
    {
        if let name = userPrefs?.cityName
        {
            self.getWeather(byCityName: name)
        }
    }
    
    func getWeather(byCityName cityName: String)
    {
        weatherSama.weatherByCityName(cityName: cityName, countryCode: nil, requestType: .dailyForecast)
        { (isSuccess: Bool, description: String, classModel: AnyObject) -> () in
            if isSuccess
            {
                // you can user response json or class model
                print("response json : \(description)")
                guard let model = classModel as? DailyForecastModel else
                {
                    print("Unable to read DailyForecastModel")
                    return
                }
                
                self.dailyForecast = model
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DataManager.NewDataArrivedNotificationName), object: nil)
            }
            else
            {
                print("response error : \(description)")
            }

        }
    }
    
    func getForecast()
    {
        if let name = userPrefs?.cityName
        {
            self.getForecast(byCityName: name)
        }
    }
    
    func getForecast(byCityName cityName: String)
    {
        weatherSama.weatherByCityName(cityName: cityName, countryCode: nil, requestType: .Weather)
        { (isSuccess: Bool, description: String, classModel: AnyObject) -> () in
            if isSuccess
            {
                // you can user response json or class model
                print("response json : \(description)")
                guard let model = classModel as? WeatherModel else
                {
                    print("Unable to read DailyForecastModel")
                    return
                }
                
                self.currentWeather = model
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DataManager.NewDataArrivedNotificationName), object: nil)
            }
            else
            {
                print("response error : \(description)")
            }
            
        }
    }

}

extension DataManager
{
    static func printableTemp(temp: Double) -> String
    {
        let out = "\(Int(temp.rounded()))°"
        return out
    }
    
    static func printableHumidity(humdity: Int) -> String
    {
        let out = "\(humdity)%"
        return out
    }
    
    static func printableWind(speed: Double, deg: Int) -> String
    {
        let angle = Double(deg)
        let out = "\(Int(speed.rounded())) km/h \(angle.direction)"
        return out
    }
    
    static func printablePressure(pressure: Double) -> String
    {
        let out = "\(Int(pressure.rounded())) hPa"
        return out
    }
}
