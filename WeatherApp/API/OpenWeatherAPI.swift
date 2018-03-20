//
//  OpenWeatherAPI.swift
//  WeatherApp
//
//  Copyright © 2018 Alexsays. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherAPI {

    static let shared = OpenWeatherAPI()

    private init() { }

    func getWeatherByCoordinates(lat: Double, long: Double, completion: @escaping (WeatherModel?, Error?) -> Void) {
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=ed5ece54f7caa5d8f3703bceb585aee3")
            .responseJSON { response in
                if let jsonDict = response.result.value as? [String:Any] {
                    let weather = WeatherModel(dict: jsonDict)
                    weather.saveToLocalStorage()
                    completion(weather, nil)
                } else {
                    completion(nil, response.result.error)
                }
        }
    }

}
