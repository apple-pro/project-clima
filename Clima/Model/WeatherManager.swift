//
//  WeatherManager.swift
//  Clima
//
//  Created by StartupBuilder.INFO on 8/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

typealias Temperature = Float
typealias Lat = Double
typealias Lon = Double

extension Temperature {
    func fancy() -> String {
        return String(format: "%.1f", self)
    }
}

class WeatherManager {
    
    let apiKey = "fd2d0fff71ee3c5afb66bbfc822758d8"
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(byCity city: String) {
        let urlString = "\(weatherUrl)?q=\(city)&appid=\(apiKey)&units=metric"
        fetchWeather(byUrlString: urlString)
    }
    
    func fetchWeather(byLat lat: Lat, andLon lon: Lon) {
        let urlString = "\(weatherUrl)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        fetchWeather(byUrlString: urlString)
    }
    
    private func fetchWeather(byUrlString urlStr: String) {
        if let url = URL(string: urlStr) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.weatherManagerDidCreateError(weatherManager: self, error: error!)
                    return
                }
                
                if let safeData = data {
                    let result = self.parseJSON(weatherData: safeData)
                    
                    if let sw = result.0 {
                        let weather = Weather(city: sw.name, temp: sw.main.temp, weatherConditionId: sw.weather[0].id)
                        self.delegate?.weatherManagerDidUpdate(weatherManager: self, weather: weather)
                    } else {
                        self.delegate?.weatherManagerDidCreateError(weatherManager: self, error: result.1!)
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    private func parseJSON(weatherData: Data) -> (WeatherResultJson?, Error?) {
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

protocol WeatherManagerDelegate {
    func weatherManagerDidUpdate(weatherManager: WeatherManager, weather: Weather)
    func weatherManagerDidCreateError(weatherManager: WeatherManager, error: Error)
}

struct Weather {
    let city: String
    let temp: Temperature
    let weatherConditionId: Int
    
    var icon: String {
        get {
            switch weatherConditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
            }
        }
    }
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
