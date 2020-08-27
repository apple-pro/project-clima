//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            print("Location: \(lastLocation.coordinate)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error")
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if "" == searchTextField.text {
            searchTextField.placeholder = "Enter a city..."
            return false
        }
        
        searchTextField.placeholder = "Search"
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = searchTextField.text ?? ""
        
        searchTextField.text = ""
        
        print(text)
        
        weatherManager.fetchWeather(city: text) { (weatherData, error) in
            if let w = weatherData {
                DispatchQueue.main.async {
                    self.cityLabel.text = w.city
                    self.temperatureLabel.text = w.temp.fancy()
                    self.conditionImageView.image = UIImage(systemName: w.icon)
                }
            }
        }
    }
}

