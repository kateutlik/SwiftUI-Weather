//
//  WeatherAppService.swift
//  SwiftUI-Weather
//
//  Created by Katerina Utlik on 3/29/21.
//

import Foundation

struct WeatherAppService {
    static let YOUR_ACCESS_KEY = "eccc875b690c8ba08298539631a7f185"
    
    static func getWeatherData(cityName: String, completionHandler: @escaping (Weather) -> Void) {
        let urlString = "http://api.weatherstack.com/current?access_key=\(YOUR_ACCESS_KEY)&query=\(cityName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString!) else { return }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }

            do {
                print("2 - received weather for \(cityName)")
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completionHandler(weather)
            } catch let err {
                print("Json Error", err)
            }
        }
        
        task.resume()
    }
}

struct Request: Decodable {
    let type: String?
    let query: String?
    let language: String?
    let unit: String?
}

struct Location: Decodable {
    let name: String?
    let country: String?
    let region: String?
    let lat: String?
    let lon: String?
    let timezone_id: String?
    let localtime: String?
    let localtime_epoch: Int?
    let utc_offcet: String?
}

struct Current: Decodable {
    let observation_time: String?
    let temperature: Int?
    let weather_code: Int?
    let weather_icons: [String?]
    let weather_descriptions: [String?]
    let wind_speed: Int?
    let wind_degree: Int?
    let wind_dir: String?
    let pressure: Int?
    let precip: Double?
    let humidity: Int?
    let cloudcover: Int?
    let feelslike: Int?
    let uv_index: Int?
    let visibility: Int?
}

struct Weather: Decodable {
    let request: Request?
    let location: Location?
    let current: Current?
}
