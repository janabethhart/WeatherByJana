//
//  DailyForecastTableViewCell.swift
//  WeatherByJana
//
//  Created by Jana Beth Hart on 6/19/19.
//

import UIKit
import Weathersama

class DailyForecastTableViewCell: UITableViewCell
{
    static let identifier = "DailyForecastTableCellID"
    let oneDayInSeconds = (60 * 60 * 24)
    
    @IBOutlet var conditionIcon: UIImageView!
    @IBOutlet var condition: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var tempHigh: UILabel!
    @IBOutlet var tempLow: UILabel!
    @IBOutlet var extraInfoStack: UIStackView!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var wind: UILabel!
    @IBOutlet var pressure: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        var reallySelected = selected
        
        if reallySelected && isSelected
        {
            reallySelected = !selected
        }
        
        super.setSelected(reallySelected, animated: animated)
        
        // Configure the view for the selected state
        if reallySelected
        {
            extraInfoStack.isHidden = false
        }
        else
        {
            extraInfoStack.isHidden = true
        }
    }

    func assignValuesFromModel(_ model: DailyForecastListModel, index: Int)
    {
        condition.text = model.weather.first?.description.capitalized
        day.text = determineDayOfWeek(index: index)
        tempLow.text = DataManager.printableTemp(temp: model.temperature.min)
        tempHigh.text = DataManager.printableTemp(temp: model.temperature.max)
        humidity.text = "Humidity: " + DataManager.printableHumidity(humdity: model.humidity)
        wind.text = "Wind: " + DataManager.printableWind(speed: model.speed, deg: model.deg)
        pressure.text = "Pressure: " + DataManager.printablePressure(pressure: model.pressure)
        
        if let iconName = model.weather.first?.icon
        {
            let wc = WeatherConditionFromWeatherIconName(iconName)
            let images = wc.icon
            conditionIcon.image = images.1
        }
    }
    
    func determineDayOfWeek(index: Int) -> String
    {
        let dayIncrement = Double(index * oneDayInSeconds)
        let date = Date()
        let myDate = date.addingTimeInterval(dayIncrement)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MM/dd"
        
        let dayOfWeekString = dateFormatter.string(from: myDate)
        return dayOfWeekString
    }
    
}

