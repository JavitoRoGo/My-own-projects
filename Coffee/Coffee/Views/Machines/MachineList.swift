//
//  MachineList.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 18/12/21.
//

import SwiftUI

struct MachineList: View {
    @EnvironmentObject var model: MachineModel
    
    var body: some View {
        NavigationView {
            List(model.machines) { machine in
                NavigationLink(destination: MachineDetail(machine: machine)) {
                    MachineRow(machine: machine)
                }
            }
            .navigationTitle("Máquinas")
        }
    }
}

struct MachineList_Previews: PreviewProvider {
    static var previews: some View {
        MachineList()
            .environmentObject(MachineModel())
    }
}
