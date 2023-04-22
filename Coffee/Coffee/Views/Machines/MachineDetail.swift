//
//  MachineDetail.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 18/12/21.
//

import SwiftUI

struct MachineDetail: View {
    @EnvironmentObject var model: MachineModel
    let machine: CoffeeMachine
    
    var body: some View {
        ScrollView {
            Image(machine.image)
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(color: .gray, radius: 7)
            
            VStack(alignment: .leading) {
                Text("Acerca de \(machine.name):")
                    .font(.title2)
                    .padding(.bottom, 8)
                HStack {
                    Text("Color: \(machine.color)")
                    Spacer()
                    Text("Precio: " + priceFormatter.string(from: NSNumber(value: machine.price))!)
                }
                Text("Fecha de compra: " + machine.purchasingDate)
            }
            .padding([.top, .leading, .trailing])
            
            Divider()
            Text("Total de cápsulas: \(model.totalAmount(machine).formatted(.number.grouping(.never)))")
                .font(.title)
                .padding(.top)
            
            MachineStatistic(machine: machine)
                .frame(width: 400, height: 400)
        }
        .navigationTitle(machine.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct MachineDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MachineDetail(machine: MachineModel().machines[0])
                .environmentObject(MachineModel())
        }
    }
}
