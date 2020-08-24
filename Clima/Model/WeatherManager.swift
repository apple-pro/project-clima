//
//  WeatherManager.swift
//  Clima
//
//  Created by StartupBuilder.INFO on 8/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class WeatherManager {
    
    let weatherUrl = "https://jsonplaceholder.typicode.com/todos/1"
        
    func fetchWeather(city: String) {
        if let url = URL(string: weatherUrl) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handleResponse(data:respomse:error:))
            
            task.resume()
        }
    }
    
    func handleResponse(data: Data?, respomse: URLResponse?, error: Error?) {
        if error != nil {
            print(error)
            return
        }
        
        if let safeData = data {
            print(String(data: safeData, encoding: .utf8))
        }
        
    }
}
