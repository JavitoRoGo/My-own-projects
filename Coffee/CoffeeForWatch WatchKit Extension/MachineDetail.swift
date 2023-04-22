//
//  MachineDetail.swift
//  CoffeeForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 10/3/22.
//

import SwiftUI

struct MachineDetail: View {
    @EnvironmentObject var model: MachineModel
    let machine: CoffeeMachine
    
    var body: some View {
        ScrollView {
            Image(machine.image)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 2)
                }
                .shadow(color: .gray, radius: 7)
            
            VStack {
                Text("Acerca de \(machine.name):")
                    .font(.title3)
                    .padding(.bottom, 8)
                HStack {
                    Text("Color: \(machine.color)")
                    Spacer()
                    Text("Precio: " + priceFormatter.string(from: NSNumber(value: machine.price))!)
                }
                Text("Fecha de compra: " + machine.purchasingDate)
            }
            
            Divider()
            Text("Total de cápsulas: \(model.totalAmount(machine).formatted(.number.grouping(.never)))")
                .font(.title2)
        }
    }
}

struct MachineDetail_Previews: PreviewProvider {
    static var previews: some View {
        MachineDetail(machine: CoffeeMachine.example)
            .environmentObject(MachineModel())
    }
}
