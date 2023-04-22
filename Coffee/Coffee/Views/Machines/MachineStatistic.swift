//
//  MachineStatistic.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 19/12/21.
//

import SwiftUI

struct MachineStatistic: View {
    @EnvironmentObject var model: MachineModel
    let machine: CoffeeMachine
    
    var body: some View {
        List(Year.allCases.reversed()) { year in
            HStack {
                Text(String(year.rawValue))
                Spacer()
                Text(priceFormatter.string(from: NSNumber(value: model.pricePerYear(machine, year: year)))!)
                Spacer()
                Text(String(model.numPerYear(machine, year: year)))
            }
            #if os(macOS)
            .font(.title2)
            #endif
        }
        #if os(macOS)
        .listStyle(.bordered(alternatesRowBackgrounds: true))
        #endif
    }
}

struct MachineStatistic_Previews: PreviewProvider {
    static var previews: some View {
        MachineStatistic(machine: MachineModel().machines[0])
            .environmentObject(MachineModel())
    }
}
