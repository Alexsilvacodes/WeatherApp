//
//  WheaterModel.swift
//  WeatherApp
//
//  Copyright © 2018 Alexsays. All rights reserved.
//

import Foundation

class WeatherModel {

    var placeName: String!
    var conditionIcon: String!
    var conditionText: String!
    var windSpeed: Double!
    var windOrigin: Double!
    var currTemp: Double!
    var minTemp: Double!
    var maxTemp: Double!

    init(dict: [String:Any]) {
        if let placeName = dict["name"] as? String {
            self.placeName = placeName
        }
        if let weatherArr = dict["weather"] as? [Any], let weather = weatherArr.first as? [String:Any] {
            if let conditionIcon = weather["icon"] as? String {
                self.conditionIcon = conditionIcon
            }
            if let conditionText = weather["description"] as? String {
                self.conditionText = conditionText
            }
        }
        if let wind = dict["wind"] as? [String:Any] {
            if let windSpeed = wind["speed"] as? Double {
                self.windSpeed = windSpeed
            }
            if let windOrigin = wind["deg"] as? Double {
                self.windOrigin = windOrigin
            }
        }
        if let main = dict["main"] as? [String:Any] {
            if let currTemp = main["temp"] as? Double {
                self.currTemp = currTemp
            }
            if let minTemp = main["temp_min"] as? Double {
                self.minTemp = minTemp
            }
            if let maxTemp = main["temp_max"] as? Double {
                self.maxTemp = maxTemp
            }
        }
    }

    func saveToLocalStorage() {
        let weatherData: [String:Any] = [
            "name": placeName,
            "weather": [[
                "icon": conditionIcon,
                "description": conditionText
            ]],
            "wind": [
                "speed": windSpeed,
                "deg": windOrigin
            ],
            "main": [
                "temp": currTemp,
                "temp_min": minTemp,
                "temp_max": maxTemp
            ]
        ]
        UserDefaults.standard.setValue(weatherData, forKey: "weatherData")
        UserDefaults.standard.synchronize()
    }

    static func loadFromLocalStorage() -> WeatherModel? {
        let weatherData = UserDefaults.standard.object(forKey: "weatherData") as! [String:Any]
        return WeatherModel(dict: weatherData)
    }

}
