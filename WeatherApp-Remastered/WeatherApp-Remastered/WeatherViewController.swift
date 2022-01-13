//
//  ViewController.swift
//  WeatherApp-Remastered
//
//  Created by Maitree Bain on 12/23/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //set up location manager
    let locationManager = CLLocationManager()
    //set up tableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Weather"
        locationManager.delegate = self
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func applyConstraints() {
        
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            Task { @MainActor in
                do {
                    let locationRequest = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)")! )
                    let (locationData, _) = try await URLSession.shared.data(for: locationRequest)
                    let locations = try JSONDecoder().decode([Location].self, from: locationData)

                    let weatherRequest = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/\(locations[0].woeid)")!)
                    let (weatherData, _) = try await URLSession.shared.data(for: weatherRequest)
                    let weather = try JSONDecoder().decode(WeatherEnvelope.self, from: weatherData)

                    print(weather.consolidated_weather)
                } catch {
                    // error
                }
            }



//            URLSession.shared.dataTask(with: locationRequest) { (data, response, error) in
//                print("location request", data)
//                if let data = data {
//                    do {
//                        let locationItems = try JSONDecoder().decode([Location].self, from: data)
//
//                        let request = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/\(locationItems[0].woeid)")!)
//
//                        URLSession.shared.dataTask(with: request) { (data, _, _) in
//                            print("weather request", data)
//                            if let data = data {
//                                do {
//                                    let weatherItems = try JSONDecoder().decode(WeatherEnvelope.self, from: data)
//
//                                    print(weatherItems.consolidated_weather)
//                                } catch {
//                                    print("weather did not decode")
//                                }
//                            }
//                        }.resume()
//                    } catch {
//                        print("location did not decode")
//                    }
//                }
//            }.resume()
        }
    }
}
struct Location: Decodable {
    let title: String
    let woeid: Int
}

struct WeatherEnvelope: Decodable {
    let consolidated_weather: [Weather]
}

struct Weather: Decodable {
    let min_temp: Double
    let max_temp: Double
    let the_temp: Double
}
