//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Katerina Utlik on 3/26/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherApp = WeatherApp()
    @State private var selectedView = 0
    
    var body: some View {
        TabView(selection: $selectedView) {
            ForEach(weatherApp.cities) { city in
                WeatherCityView(weatherApp: weatherApp, weatherData: weatherApp.weatherData, city: city, selectedView: $selectedView)
                    .tabItem {
                        Image(systemName: "\(city.id + 1).circle.fill")
                        Text("\(city.name)")
                    }
                    .tag(city.id)
            }
        }
        .onAppear() {
            weatherApp.fetchData(for: weatherApp.cities[selectedView].name)
        }
        .onChange(of: selectedView) { newState in
            print("selectedView \(newState)")
            weatherApp.fetchData(for: weatherApp.cities[newState].name)
        }
    }
}

struct WeatherCityView: View {
    var weatherApp: WeatherApp
    var weatherData: WeatherData
    var city: WeatherCity
    @Binding var selectedView: Int

    var body: some View {
        ZStack {
            weatherApp.weatherData.background
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                if weatherApp.weatherData.loaded {
                    CityTextView(cityName: weatherApp.weatherData.city, cityTime: weatherApp.weatherData.localtime, weatherDescription: weatherApp.weatherData.description)
                    
                    Spacer()
                    
                    MainWeatherStatusView(imageName: weatherApp.weatherData.imageName, temperature: weatherApp.weatherData.temperature)

                    Spacer()
                    
                    HStack(spacing: 20) {
                        ForEach(weatherApp.weatherDays) { weatherDay in
                            WeatherDayView(weatherDay: weatherDay)
                        }
                    }

                    Spacer()
                    
                    Button {
                        weatherApp.fetchData(for: city.name)
                    } label: {
                        WeatherButton(title: "Update data", textColor: .white)
                    }
                    .padding(.bottom)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
        .foregroundColor(.white)
    }
}

struct WeatherDayView: View {
    var weatherDay: WeatherDay

    var body: some View {
        VStack(spacing: 10) {
            Text(weatherDay.dayOfWeek.uppercased())
                .font(.system(size: 16, weight: .medium, design: .default))
            Image(systemName: weatherDay.imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(weatherDay.temperature)°")
                .font(.system(size: 28, weight: .medium, design: .default))
        }
    }
}

struct CityTextView: View {
    var cityName: String
    var cityTime: String
    var weatherDescription: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 40, weight: .medium, design: .default))
            .padding(.top, 60)
        Text(weatherDescription)
            .font(.system(size: 25))
            .padding(.bottom)
    }
}

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
            
        }
        .padding(.bottom, 40)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
