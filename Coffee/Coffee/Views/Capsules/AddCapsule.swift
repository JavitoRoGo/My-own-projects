//
//  AddCapsule.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 15/4/22.
//

import SwiftUI

struct AddCapsule: View {
    @EnvironmentObject var model: CapsuleModel
    @Environment(\.dismiss) var dismiss
    @State private var newName = ""
    @State private var newImageName = ""
    @State private var newIntensity = 0
    @State private var newPrice = 0.0
    var isDisabled: Bool {
        guard newName.isEmpty || newImageName.isEmpty || newIntensity == 0 || newPrice == 0 else { return false }
        return true
    }
    
    var body: some View {
        Form {
            TextField("Escribe el nombre", text: $newName)
            TextField("Escribe el nombre para la imagen", text: $newImageName)
            TextField("", value: $newIntensity, format: .number)
            TextField("", value: $newPrice, format: .currency(code: "eur"))
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar") {
                    let newCapsule = CoffeCapsule(name: newName, image: newImageName, intensity: newIntensity, price: newPrice, isRecent: true, amount: [])
                    model.capsules.append(newCapsule)
                    dismiss()
                }
                .disabled(isDisabled)
            }
        }
    }
}

struct AddCapsule_Previews: PreviewProvider {
    static var previews: some View {
        AddCapsule()
            .environmentObject(CapsuleModel())
    }
}
