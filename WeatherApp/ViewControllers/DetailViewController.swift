//
//  DetailViewController.swift
//  WeatherApp
//
//  Copyright © 2018 Alexsays. All rights reserved.
//

import UIKit
import CoreLocation
import Reachability
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var cTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var wSpeedLabel: UILabel!
    @IBOutlet weak var wOriginLabel: UILabel!

    var location: CLLocationCoordinate2D!
    private let reachability = Reachability()

    // MARK: - UI life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
    }

    private func prepareUI() {
        if reachability?.connection == Reachability.Connection.none {
            title = "No Connection Mode"
            let weather = WeatherModel.loadFromLocalStorage()
            if let weather = weather {
                fillWeatherData(weather: weather)
            } else {
                showWeatherError()
            }
        } else {
            title = "Current Weather"
            OpenWeatherAPI.shared
                .getWeatherByCoordinates(lat: location.latitude,
                                         long: location.longitude) { weather, error in
                                            DispatchQueue.main.async {
                                                if let weather = weather {
                                                    self.fillWeatherData(weather: weather)
                                                } else {
                                                    self.showWeatherError()
                                                }
                                            }
            }
        }
    }

    private func fillWeatherData(weather: WeatherModel) {
        self.nameLabel.text = weather.placeName
        let iconURL = URL(string: "http://openweathermap.org/img/w/\(weather.conditionIcon).png")
        self.iconImageView.sd_setImage(with: iconURL, placeholderImage: R.image.locArrow())
        self.descLabel.text = weather.conditionText
        self.cTempLabel.text = "\(weather.currTemp) Fº"
        self.minTempLabel.text = "\(weather.minTemp) Fº"
        self.maxTempLabel.text = "\(weather.maxTemp) Fº"
        self.wSpeedLabel.text = "\(weather.windSpeed) m/h"
        self.wOriginLabel.text = "\(weather.windOrigin) deg"
    }

    // MARK: - Alerts

    private func showWeatherError() {
        let ok = UIAlertAction("Ok") { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let alert = UIAlertController(title: "Data error",
                                      message: "There was an error retrieving Weather data ❄️", style: .alert, actions: [ok])
        present(alert, animated: true)
    }

}
