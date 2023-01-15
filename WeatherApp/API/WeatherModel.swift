import Foundation

struct WeatherModel: Decodable {
    struct Weather: Decodable {
        var icon: String
        var description: String
    }

    struct Wind: Decodable {
        var speed: Double
        var deg: Double
    }

    struct Main: Decodable {
        var temp: Double
        var tempMin: Double
        var tempMax: Double
    }

    let placeName: String
    let weather: [Weather]
    let wind: Wind
    let main: Main

    var windSpeed: Double { wind.speed }
    var windOrigin: Double { wind.deg }
    var currTemp: Double { main.temp }
    var minTemp: Double { main.tempMin }
    var maxTemp: Double { main.tempMax }

    enum CodingKeys: String, CodingKey {
        case placeName = "name"
        case weather
        case wind
        case main
    }

    func saveToLocalStorage() {
        let weatherData: [String:Any] = [
            "name": placeName,
            "weather": [[
                "icon": weather.first?.icon ?? "",
                "description": weather.first?.description ?? ""
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
        return UserDefaults.standard.object(forKey: "weatherData") as? WeatherModel
    }

}
