//
//  Prueba.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 4/12/22.
//

import Charts
import SwiftUI

struct ComplexData: Identifiable {
    let name: String
    let dates: [Date]
    let datas: [Double]
    var id: String {
        name
    }
}

struct ComplexDataView: View {
    @EnvironmentObject var model: MyViewModel
    let pickerSelection: Int
    
    var complexDatas: [ComplexData] {
        switch pickerSelection {
        case 1:
            return [.init(name: "Correr", dates: model.runningDates, datas: model.runningLength),
                    .init(name: "Caminar", dates: model.walkingDates, datas: model.walkingLength)]
        case 2:
            return [.init(name: "Correr", dates: model.runningDates, datas: model.runningVelocity),
                    .init(name: "Caminar", dates: model.walkingDates, datas: model.walkingVelocity)]
        case 3:
            return [.init(name: "Correr", dates: model.runningDates, datas: model.runningCals),
                    .init(name: "Caminar", dates: model.walkingDates, datas: model.walkingCals)
            ]
        case 4:
            return [.init(name: "Correr", dates: model.runningDates, datas: model.runningHR),
                    .init(name: "Caminar", dates: model.walkingDates, datas: model.walkingHR)
            ]
        default:
            return [.init(name: "Correr", dates: model.runningDates, datas: model.runningDuration),
                    .init(name: "Caminar", dates: model.walkingDates, datas: model.walkingDuration)]
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Chart(complexDatas) { serie in
                ForEach(0..<serie.dates.count, id:\.self) { index in
                    PointMark(
                        x: .value("Fecha", serie.dates[index]),
                        y: .value("Valor", serie.datas[index])
                    )
                    .foregroundStyle(by: .value("Tipo", serie.name))
                    LineMark(
                        x: .value("Fecha", serie.dates[index]),
                        y: .value("Valor", serie.datas[index])
                    )
                    .foregroundStyle(by: .value("Tipo", serie.name))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartForegroundStyleScale(["Correr" : .orange, "Caminar" : .green])
        }
    }
}

struct Prueba_Previews: PreviewProvider {
    static var previews: some View {
        ComplexDataView(pickerSelection: 0)
            .environmentObject(MyViewModel())
    }
}
