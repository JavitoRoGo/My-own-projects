//
//  NewMask.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 16/12/21.
//

import SwiftUI

struct NewMask: View {
    @EnvironmentObject var model: MasksModel
    @State private var newName = ""
    @State private var newOwner: Owner = .javi
    
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        let newID = model.masks.count + 1
        VStack {
            Form {
                Text("ID: \(newID)")
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Nombre:").bold()
                    TextField("Nombre de la mascarilla", text: $newName)
                }
                .padding(.bottom, 25)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Propietario:").bold()
                    Picker("Elige un propietario", selection: $newOwner) {
                        ForEach(Owner.allCases) { owner in
                            Text(owner.rawValue).tag(owner)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .font(.title3)
            .frame(width: 400, height: 300)
            
            ChoosingImage()
            Spacer()
        }
        .navigationTitle("Añadir mascarilla")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Guardar") {
                let newMask = Masks(id: newID, name: newName, owner: newOwner, washes: [], dates: [], image: newName.lowercased(), isActive: true)
                model.masks.append(newMask)
                showingAlert = true
            }
            .alert("Se ha creado la nueva mascarilla.", isPresented: $showingAlert) {
                Button("Aceptar", role: .none) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct NewMask_Previews: PreviewProvider {
    static var previews: some View {
        NewMask()
            .environmentObject(MasksModel())
    }
}

/*
 var id: Int
 var name: String
 var owner: Owner
 var washes: [Int]
 var dates: [String]
 var image: String
 var isActive: Bool
 */
