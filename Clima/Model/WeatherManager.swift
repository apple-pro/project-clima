//
//  WeatherManager.swift
//  Clima
//
//  Created by StartupBuilder.INFO on 8/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class WeatherManager {
    
    let apiKey = "fd2d0fff71ee3c5afb66bbfc822758d8"
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
        
    func fetchWeather(city: String) {
        if let url = URL(string: "\(weatherUrl)?q=\(city)&appid=\(apiKey)&units=metric") {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handleResponse(data:respomse:error:))
            
            task.resume()
        }
    }
    
    func handleResponse(data: Data?, respomse: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataStr = String(data: safeData, encoding: .utf8)
            print(dataStr)
        }
        
    }
}
