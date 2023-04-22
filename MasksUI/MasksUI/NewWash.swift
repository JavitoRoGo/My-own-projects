//
//  NewWash.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 14/12/21.
//

import SwiftUI

struct NewWash: View {
    @EnvironmentObject var model: MasksModel
    @Binding var mask: Masks
    @State private var date = Date.now
    @State private var showingAlert = false
    @State private var num = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Cerrar") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding([.top, .trailing], 10.0)
            }
            Spacer()
            Image(mask.image)
                .resizable()
                .scaledToFit()
            Spacer()
            Divider()
            Text("Has elegido añadir un nuevo lavado.")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            Divider()
            Text("Selecciona la fecha:")
                .font(.title2)
            DatePicker("", selection: $date, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
            Button("Añadir") {
                num = mask.washes.count
                if num < 50 {
                    num += 1
                    mask.washes.append(num)
                    mask.dates.append(dateFormatter(date))
                }
                showingAlert.toggle()
            }
            .alert(num < 50 ? "Se ha añadido correctamente el nuevo lavado." : "Se han alcanzado los 50 lavados.\nEsta mascarilla ya no puede usarse", isPresented: $showingAlert) {
                Button("Aceptar", role: .none) {
                    if num >= 50 {
                        mask.isActive = false
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct NewWash_Previews: PreviewProvider {
    static var previews: some View {
        NewWash(mask: .constant(MasksModel().masks[2]))
            .environmentObject(MasksModel())
    }
}
