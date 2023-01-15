import UIKit
import MapKit

final class MainViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!

    private var selectedLocation: CLLocationCoordinate2D!

    // MARK: - UI life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        initializeLocation()
    }

    // MARK: - Helpers

    private func prepareUI() {
        title = "Weather App"
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapMap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        mapView.addGestureRecognizer(doubleTapGesture)
    }

    private func initializeLocation() {
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self?.locationManager = CLLocationManager()
                    self?.locationManager.delegate = self
                    self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self?.locationManager.requestAlwaysAuthorization()
                }
            } else {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: R.segue.mainViewController.showLocationUnavailable, sender: self)
                }
            }
        }
    }

    private func checkLocationAvailability(manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            self.performSegue(withIdentifier: R.segue.mainViewController.showLocationUnavailable, sender: self)
        @unknown default:
            fatalError()
        }
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DetailViewController {
            let destination = segue.destination as! DetailViewController
            destination.location = selectedLocation
        }
    }

    // MARK: - Actions

    @objc private func doubleTapMap(_ sender: UITapGestureRecognizer) {
        let touchedPoint = sender.location(in: mapView)
        selectedLocation = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
        performSegue(withIdentifier: R.segue.mainViewController.showDetail, sender: self)
    }

    @IBAction func centerTouched(_ sender: UIButton) {
        checkLocationAvailability(manager: locationManager)
    }

}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span =  MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)

            locationManager.stopUpdatingLocation()

            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                DispatchQueue.main.async {
                    if let placemarks = placemarks, let city = placemarks.first?.locality {
                        self.title = "Weather in '\(city)'"
                    } else {
                        self.title = "Weather App"
                    }
                }
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAvailability(manager: manager)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
