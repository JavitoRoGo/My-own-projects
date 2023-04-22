//
//  MachineList.swift
//  CoffeeForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 10/3/22.
//

import SwiftUI

struct MachineList: View {
    @EnvironmentObject var model: MachineModel
    
    var body: some View {
        List(model.machines) { machine in
            NavigationLink(destination: MachineDetail(machine: machine)) {
                MachineRow(machine: machine)
            }
        }
    }
}

struct MachineList_Previews: PreviewProvider {
    static var previews: some View {
        MachineList()
            .environmentObject(MachineModel())
    }
}
