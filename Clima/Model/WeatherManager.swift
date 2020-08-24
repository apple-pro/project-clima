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
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
                
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(WeatherData.self, from: weatherData)
            print("result: \(decoded)")
        } catch {
            print(error)
        }
    }
    
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Float
}


struct Weather: Decodable {
    let id: Int
    let description: String
}
