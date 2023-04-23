//
//  ContentView.swift
//  PruebaML
//
//  Created by Javier Rodríguez Gómez on 14/10/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var pages: Double = 0
    @State private var finishingTime: Double = 0
    
    var fecha: Date {
        var components = DateComponents()
        components.second = Int(finishingTime)
        return Calendar.current.date(from: components) ?? .now
    }
    var segundos: String {
        let hours = Int(finishingTime / 3600)
        let minutes = Int(finishingTime / 60) % 60
        let seconds = Int(finishingTime) % 60
        return "\(hours < 10 ? "0\(hours)" : "\(hours)"):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Text("Indica el número de páginas:")
                TextField("", value: $pages, format: .number)
                    .textFieldStyle(.roundedBorder)
                Button("Calcular") {
                    calcDate()
                }
                .buttonStyle(.bordered)
                Text(Date().addingTimeInterval(finishingTime).formatted(date: .complete, time: .complete))
                Text(segundos)
            }
            .padding()
            .navigationTitle("Prueba de ML")
        }
    }
    
    func calcDate() {
        do {
            let config = MLModelConfiguration()
            let model = try MyMLTest(configuration: config)
            
            let prediction = try model.prediction(pages: pages)
            finishingTime = prediction.duration
        } catch {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
