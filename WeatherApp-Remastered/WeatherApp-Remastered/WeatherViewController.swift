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
        locationManager.requestLocation()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func applyConstraints() {
        
    }

}

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
             let latitude = location.coordinate.latitude
             let longitude = location.coordinate.longitude
         }
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
