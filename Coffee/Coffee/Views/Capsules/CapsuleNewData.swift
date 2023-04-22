//
//  CapsuleNewData.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 21/12/21.
//

import SwiftUI

struct CapsuleNewData: View {
    @Binding var capsule: CoffeCapsule
    @State private var yearSelection: Year = .allCases.last!
    @State private var machineSelection: Machines = .essenzaMini
    @State private var numberSelection: Int = 10
    var numbers = [10, 20, 30, 40, 50, 60, 70, 80, 90]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text(capsule.name)
                Spacer()
                Button("Añadir") {
                    let amount = CoffeCapsule.Amount(number: numberSelection, machine: machineSelection, year: yearSelection)
                    capsule.amount.append(amount)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.bottom, 10)
            
            List {
                HStack {
                    Text("Año:")
                    Spacer()
                    Picker("Año", selection: $yearSelection) {
                        ForEach(Year.allCases.reversed(), id: \.self) { year in
                            Text(String(year.rawValue))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                HStack {
                    Text("Máquina:")
                    Spacer()
                    Picker("Máquina", selection: $machineSelection) {
                        ForEach(Machines.allCases.reversed(), id: \.self) { machine in
                            Text(machine.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
                
                HStack {
                    Text("Cantidad:")
                    Spacer()
                    Picker("Cantidad", selection: $numberSelection) {
                        ForEach(numbers, id: \.self) { number in
                            Text("+\(number)")
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: 120)
                }
            }
            .padding([.top, .leading, .trailing], -12)
            .frame(width: 382, height: 190)
            
            Spacer()
        }
        .padding()
    }
}

struct CapsuleNewData_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleNewData(capsule: .constant(CapsuleModel().capsules[0]))
            .environmentObject(CapsuleModel())
    }
}
