//
//  CapsuleStatistic.swift
//  CoffeeForMac
//
//  Created by Javier Rodríguez Gómez on 9/3/22.
//

import SwiftUI

struct CapsuleStatistic: View {
    @EnvironmentObject var model: CapsuleModel
    let capsule: CoffeCapsule
    
    var body: some View {
        List {
            Section("Por máquina") {
                ForEach(Machines.allCases.reversed()) { machine in
                    HStack {
                        Text(machine.rawValue)
                        Spacer()
                        Text(String(model.numberPerMachine(capsule, machine: machine)))
                    }
                    .font(.title2)
                }
            }
            
            Section("Por año") {
                ForEach(Year.allCases.reversed()) { year in
                    HStack {
                        Text(String(year.rawValue))
                        Spacer()
                        Text(priceFormatter.string(from: NSNumber(value: model.pricePerYear(capsule, year: year)))!)
                        Spacer()
                        Text(String(model.numberPerYear(capsule, year: year)))
                    }
                    .font(.title2)
                }
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
    }
}

struct CapsuleStatistic_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleStatistic(capsule: CapsuleModel().capsules[0])
            .environmentObject(CapsuleModel())
    }
}
