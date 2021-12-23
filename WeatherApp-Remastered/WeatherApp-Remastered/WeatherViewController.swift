//
//  ViewController.swift
//  WeatherApp-Remastered
//
//  Created by Maitree Bain on 12/23/21.
//

import UIKit

class WeatherViewController: UIViewController {
    
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
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func applyConstraints() {
        
    }

}

