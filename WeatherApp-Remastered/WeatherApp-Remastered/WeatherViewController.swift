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
            
            let request = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)")! )
            
            URLSession.shared.dataTask(with: request) { (data, _, _) in
                print("location request", data)
                if let data = data {
                    do {
                        let locationItems = try JSONDecoder().decode([Location].self, from: data)
                        
                        let request = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/\(locationItems[0].woeid)")!)
                        
                        URLSession.shared.dataTask(with: request) { (data, _, _) in
                            print("weather request", data)
                            if let data = data {
                                do {
                                    let weatherItems = try JSONDecoder().decode(WeatherEnvelope.self, from: data)
                                    
                                    print(weatherItems.consolidated_weather)
                                } catch {
                                    print("weather did not decode")
                                }
                            }
                        }.resume()
                    } catch {
                        print("location did not decode")
                    }
                }
            }.resume()
        }
            //    switch status {
            //        case .authorizedAlways:
            //            // Handle case
            //        case .authorizedWhenInUse:
            //            // Handle case
            //        case .denied:
            //            // Handle case
            //        case .notDetermined:
            //            // Handle case
            //        case .restricted:
            //            // Handle case
            //    }
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

/*
 
 https://www.metaweather.com/api//location/search/?lattlong=40.730610,-73.935242
 
 [{"distance":6310,"title":"New York","location_type":"City","woeid":2459115,"latt_long":"40.71455,-74.007118"},{"distance":20121,"title":"Newark","location_type":"City","woeid":2459269,"latt_long":"40.731972,-74.174179"},{"distance":80081,"title":"Bridgeport","location_type":"City","woeid":2368947,"latt_long":"41.181881,-73.191269"},{"distance":135215,"title":"Philadelphia","location_type":"City","woeid":2471217,"latt_long":"39.952271,-75.162369"},{"distance":175768,"title":"Wilmington","location_type":"City","woeid":2521358,"latt_long":"39.740231,-75.550842"},{"distance":243222,"title":"Providence","location_type":"City","woeid":2477058,"latt_long":"41.823872,-71.411987"},{"distance":278224,"title":"Baltimore","location_type":"City","woeid":2358820,"latt_long":"39.290550,-76.609596"},{"distance":300047,"title":"Boston","location_type":"City","woeid":2367105,"latt_long":"42.358631,-71.056702"},{"distance":323894,"title":"Manchester","location_type":"City","woeid":2444674,"latt_long":"42.990833,-71.463611"},{"distance":333366,"title":"Washington DC","location_type":"City","woeid":2514815,"latt_long":"38.899101,-77.028999"}]
 */

/*
 
 https://www.metaweather.com/api/location/2459115/
 
 {
 "consolidated_weather": [
 {
 "id": 4601562774110208,
 "weather_state_name": "Heavy Cloud",
 "weather_state_abbr": "hc",
 "wind_direction_compass": "NNE",
 "created": "2022-01-13T15:59:43.780923Z",
 "applicable_date": "2022-01-13",
 "min_temp": 1.405,
 "max_temp": 5.23,
 "the_temp": 4.765,
 "wind_speed": 2.8962166224899915,
 "wind_direction": 31.773384745765387,
 "air_pressure": 1016.5,
 "humidity": 60,
 "visibility": 17.58977570985445,
 "predictability": 71
 },
 {
 "id": 5494552241635328,
 "weather_state_name": "Heavy Cloud",
 "weather_state_abbr": "hc",
 "wind_direction_compass": "N",
 "created": "2022-01-13T15:59:46.622831Z",
 "applicable_date": "2022-01-14",
 "min_temp": -3.25,
 "max_temp": 5.665,
 "the_temp": 5.779999999999999,
 "wind_speed": 11.769345837124526,
 "wind_direction": 356.99999999999994,
 "air_pressure": 1008,
 "humidity": 63,
 "visibility": 17.134310625944483,
 "predictability": 71
 },
 {
 "id": 6165698763030528,
 "weather_state_name": "Heavy Cloud",
 "weather_state_abbr": "hc",
 "wind_direction_compass": "NNW",
 "created": "2022-01-13T15:59:50.103514Z",
 "applicable_date": "2022-01-15",
 "min_temp": -8.92,
 "max_temp": -3.2750000000000004,
 "the_temp": -5.645,
 "wind_speed": 9.263281570365068,
 "wind_direction": 342.1664754819252,
 "air_pressure": 1023,
 "humidity": 29,
 "visibility": 19.77389545056868,
 "predictability": 71
 },
 {
 "id": 6666697344811008,
 "weather_state_name": "Light Rain",
 "weather_state_abbr": "lr",
 "wind_direction_compass": "ENE",
 "created": "2022-01-13T15:59:52.731249Z",
 "applicable_date": "2022-01-16",
 "min_temp": -8.835,
 "max_temp": 3.02,
 "the_temp": -1.97,
 "wind_speed": 6.7155239345369715,
 "wind_direction": 61.562430849354406,
 "air_pressure": 1025.5,
 "humidity": 37,
 "visibility": 18.65946621729102,
 "predictability": 75
 },
 {
 "id": 6465855236866048,
 "weather_state_name": "Thunder",
 "weather_state_abbr": "t",
 "wind_direction_compass": "SSE",
 "created": "2022-01-13T15:59:55.589572Z",
 "applicable_date": "2022-01-17",
 "min_temp": 0.15000000000000002,
 "max_temp": 8.78,
 "the_temp": 4.24,
 "wind_speed": 14.533035626373975,
 "wind_direction": 154.46098157633034,
 "air_pressure": 988.5,
 "humidity": 84,
 "visibility": 12.057086614173228,
 "predictability": 80
 },
 {
 "id": 6436304083484672,
 "weather_state_name": "Heavy Cloud",
 "weather_state_abbr": "hc",
 "wind_direction_compass": "W",
 "created": "2022-01-13T15:59:58.834639Z",
 "applicable_date": "2022-01-18",
 "min_temp": -1.85,
 "max_temp": 2.005,
 "the_temp": 2.01,
 "wind_speed": 7.165141970890002,
 "wind_direction": 280,
 "air_pressure": 1012,
 "humidity": 66,
 "visibility": 9.999726596675416,
 "predictability": 71
 }
 ],
 "time": "2022-01-13T12:12:12.444343-05:00",
 "sun_rise": "2022-01-13T07:18:40.342838-05:00",
 "sun_set": "2022-01-13T16:51:11.542484-05:00",
 "timezone_name": "LMT",
 "parent": {
 "title": "New York",
 "location_type": "Region / State / Province",
 "woeid": 2347591,
 "latt_long": "42.855350,-76.501671"
 },
 "sources": [
 {
 "title": "BBC",
 "slug": "bbc",
 "url": "http://www.bbc.co.uk/weather/",
 "crawl_rate": 360
 },
 {
 "title": "Forecast.io",
 "slug": "forecast-io",
 "url": "http://forecast.io/",
 "crawl_rate": 480
 },
 {
 "title": "HAMweather",
 "slug": "hamweather",
 "url": "http://www.hamweather.com/",
 "crawl_rate": 360
 },
 {
 "title": "Met Office",
 "slug": "met-office",
 "url": "http://www.metoffice.gov.uk/",
 "crawl_rate": 180
 },
 {
 "title": "OpenWeatherMap",
 "slug": "openweathermap",
 "url": "http://openweathermap.org/",
 "crawl_rate": 360
 },
 {
 "title": "Weather Underground",
 "slug": "wunderground",
 "url": "https://www.wunderground.com/?apiref=fc30dc3cd224e19b",
 "crawl_rate": 720
 },
 {
 "title": "World Weather Online",
 "slug": "world-weather-online",
 "url": "http://www.worldweatheronline.com/",
 "crawl_rate": 360
 }
 ],
 "title": "New York",
 "location_type": "City",
 "woeid": 2459115,
 "latt_long": "40.71455,-74.007118",
 "timezone": "US/Eastern"
 }
 */
