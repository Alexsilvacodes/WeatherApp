import Foundation
import Alamofire

final class OpenWeatherAPI {
    static let shared = OpenWeatherAPI()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private init() { }

    func getWeatherByCoordinates(lat: Double, long: Double, completion: @escaping (WeatherModel?, Error?) -> Void) {
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=<appid>")
            .responseDecodable(of: WeatherModel.self, decoder: decoder) { response in
                switch response.result {
                case .success(let result):
                    completion(result, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
