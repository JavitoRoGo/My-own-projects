//
//  TrainingView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 2/12/22.
//

import Charts
import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var model: MyViewModel
    @State private var pickerSelection = 0
    let titles = ["dur. (min)", "long. (km)", "km/h", "kcal", "FC media"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Datos", selection: $pickerSelection.animation()) {
                    ForEach(0..<titles.count, id: \.self) {
                        Text(titles[$0])
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.horizontal)
                VStack(spacing: 20) {
                    GroupBox {
                        Text("Correr")
                        Chart(0..<model.runningDates.count, id: \.self) { index in
                            PointMark(
                                x: .value("Fecha", model.runningDates[index]),
                                y: .value("Duración", model.getRunningData(pickerSelection)[index])
                            )
                            .foregroundStyle(Color.orange.opacity(0.6))
                            LineMark(
                                x: .value("Fecha", model.runningDates[index]),
                                y: .value("Duración", model.getRunningData(pickerSelection)[index])
                            )
                            .foregroundStyle(Color.orange)
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    GroupBox {
                        Text("Caminar")
                        Chart(0..<model.walkingDates.count, id: \.self) { index in
                            PointMark(
                                x: .value("Fecha", model.walkingDates[index]),
                                y: .value("Duración", model.getWalkingData(pickerSelection)[index])
                            )
                            .foregroundStyle(Color.green.opacity(0.6))
                            LineMark(
                                x: .value("Fecha", model.walkingDates[index]),
                                y: .value("Duración", model.getWalkingData(pickerSelection)[index])
                            )
                            .foregroundStyle(Color.green)
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    GroupBox {
                        ComplexDataView(pickerSelection: pickerSelection)
                    }
                }
                .navigationTitle("Histórico por entrenamiento")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView()
            .environmentObject(MyViewModel())
    }
}
