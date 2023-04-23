//
//  ComplexDataView.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 17/12/22.
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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var ringsCD: FetchedResults<RingEntity>
    
    let pickerSelection: Int
    
    var complexDatas: [ComplexData] {
        switch pickerSelection {
        case 1:
            return [.init(name: "Correr", dates: model.runningDates(from: ringsCD), datas: model.runningLength(from: ringsCD)),
                    .init(name: "Caminar", dates: model.walkingDates(from: ringsCD), datas: model.walkingLength(from: ringsCD))]
        case 2:
            return [.init(name: "Correr", dates: model.runningDates(from: ringsCD), datas: model.runningVelocity(from: ringsCD)),
                    .init(name: "Caminar", dates: model.walkingDates(from: ringsCD), datas: model.walkingVelocity(from: ringsCD))]
        case 3:
            return [.init(name: "Correr", dates: model.runningDates(from: ringsCD), datas: model.runningCals(from: ringsCD)),
                    .init(name: "Caminar", dates: model.walkingDates(from: ringsCD), datas: model.walkingCals(from: ringsCD))
            ]
        case 4:
            return [.init(name: "Correr", dates: model.runningDates(from: ringsCD), datas: model.runningHR(from: ringsCD)),
                    .init(name: "Caminar", dates: model.walkingDates(from: ringsCD), datas: model.walkingHR(from: ringsCD))
            ]
        default:
            return [.init(name: "Correr", dates: model.runningDates(from: ringsCD), datas: model.runningDuration(from: ringsCD)),
                    .init(name: "Caminar", dates: model.walkingDates(from: ringsCD), datas: model.walkingDuration(from: ringsCD))]
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
