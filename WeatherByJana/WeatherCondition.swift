//
//  WeatherCondition.swift
//  WeatherByJana
//
//  Created by Jana Beth Hart on 6/20/19.
//

import Foundation
import UIKit

enum WeatherCondition
{
    case ClearSky
    case PartlyCloudy
    case ScatteredClouds
    case Cloudy
    case LightRain
    case Rain
    case Stormy
    case Snow
    case Mist
    
    public var icon: (UIImage?, UIImage?)
    {
        switch self
        {
        case .ClearSky:
            return (UIImage(named: "white-sunny"), UIImage(named: "black-sunny"))
        case .PartlyCloudy:
            return (UIImage(named: "white-partly-sunny"), UIImage(named: "black-partly-sunny"))
        case .ScatteredClouds:
            return (UIImage(named: "white-cloudy-2"), UIImage(named: "black-cloudy-2"))
        case .Cloudy:
            return (UIImage(named: "white-cloudy"), UIImage(named: "black-cloudy"))
        case .LightRain:
            return (UIImage(named: "white-rainy"), UIImage(named: "black-rainy"))
        case .Rain:
            return (UIImage(named: "white-rainy-2"), UIImage(named: "black-rainy-2"))
        case .Stormy:
            return (UIImage(named: "white-stormy"), UIImage(named: "black-stormy"))
            
        default:
            return (UIImage(named: "white-sunny"), UIImage(named: "black-sunny"))
        }
    }
    
}

func WeatherConditionFromWeatherIconName(_ name: String) -> WeatherCondition
{
    let component = name.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
    let list = component.filter({ $0 != "" }) // filter out all the empty strings in the component

    guard let first = list.first, let num = Int(first) else
    {
        return .ClearSky
    }
    
    switch num
    {
    case 1:
        return .ClearSky
    case 2:
        return .PartlyCloudy
    case 3:
        return .ScatteredClouds
    case 4:
        return .Cloudy
    case 9:
        return .LightRain
    case 10:
        return .Rain
    case 11:
        return .Stormy
    case 13:
        return .Snow
    case 50:
        return .Mist

    default:
        return .ClearSky
    }
}

