//
//  MachineRow.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 18/12/21.
//

import SwiftUI

struct MachineRow: View {
    @EnvironmentObject var model: MachineModel
    let machine: CoffeeMachine
    
    var body: some View {
        HStack {
            Image(machine.image)
                .resizable()
                .frame(width: 62, height: 75)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(machine.name)
                #if os(watchOS)
                    .font(.body)
                #endif
                    .font(.title2).bold()
                Text(String(model.totalAmount(machine)))
            }
            .padding(.leading, 15)
            Spacer()
        }
    }
}

struct MachineRow_Previews: PreviewProvider {
    static var previews: some View {
        MachineRow(machine: MachineModel().machines[0])
            .environmentObject(MachineModel())
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
