//
//  WeatherButton.swift
//  SwiftUI-Weather
//
//  Created by Katerina Utlik on 3/26/21.
//

import SwiftUI

struct WeatherButton: View {
    var title: String
    var textColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .border(textColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
    }
}

struct WeatherButton_Previews: PreviewProvider {
    static var previews: some View {
        WeatherButton(title: "Test Title", textColor: .white)
    }
}
