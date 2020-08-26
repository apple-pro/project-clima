//
//  WeatherManager.swift
//  Clima
//
//  Created by StartupBuilder.INFO on 8/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

typealias Temperature = Float

extension Temperature {
    func fancy() -> String {
        return String(format: "%.1f", self)
    }
}

class WeatherManager {
    
    let apiKey = "fd2d0fff71ee3c5afb66bbfc822758d8"
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(city: String, resultHandler: @escaping (Weather?, Error?) -> Void) {
        if let url = URL(string: "\(weatherUrl)?q=\(city)&appid=\(apiKey)&units=metric") {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let result = self.parseJSON(weatherData: safeData)
                    
                    if let sw = result.0 {
                        resultHandler(Weather(city: sw.name, temp: sw.main.temp, icon: "cloud"), nil)
                    } else {
                        resultHandler(nil, result.1)
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> (WeatherResultJson?, Error?) {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(WeatherResultJson.self, from: weatherData)
            print("result: \(decoded)")
            return (decoded, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
    
}

struct Weather {
    let city: String
    let temp: Temperature
    let icon: String
}

struct WeatherResultJson: Decodable {
    let name: String
    let main: MainJson
    let weather: [WeatherJson]
}

struct MainJson: Decodable {
    let temp: Float
}


struct WeatherJson: Decodable {
    let id: Int
    let description: String
}
