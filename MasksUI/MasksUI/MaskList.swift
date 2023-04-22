//
//  MaskList.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 13/12/21.
//

import SwiftUI

struct MaskList: View {
    @EnvironmentObject var model: MasksModel
    @State private var showInactive: Bool = false
    
    var body: some View {
        let filteredMasks: [Masks] = model.masks.filter {
            showInactive || $0.isActive }

        NavigationView {
            List {
                Toggle(isOn: $showInactive) {
                    Text("Mostrar inactivas (\(model.inactives))")
                }
                ForEach(filteredMasks) { mask in
                    let index = model.masks.firstIndex(of: mask)!
                    NavigationLink(destination: WashesView(mask: $model.masks[index], isActive: $model.masks[index].isActive)) {
                        HStack {
                            Image(mask.image)
                                .resizable()
                                .frame(width: 70, height: 50)
                                .cornerRadius(10)
                                .opacity(mask.isActive ? 1 : 0.25)
                            
                            VStack(alignment: .leading) {
                                Text(mask.name)
                                    .font(.headline)
                                .bold()
                                Text("\(mask.washes.count) lavados")
                                    .font(.caption)
                            }
                            .foregroundColor(mask.isActive ? .primary : .secondary)
                            
                            Spacer()
                            Image(systemName: mask.isActive ? "checkmark.square" : "xmark.square")
                                .foregroundColor(mask.isActive ? .green : .red)
                                .font(.title)
                        }
                    }
                }
            }
            .navigationTitle("Mascarillas")
            .toolbar {
                NavigationLink(destination: NewMask()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct MaskList_Previews: PreviewProvider {
    static var previews: some View {
        MaskList()
            .environmentObject(MasksModel())
    }
}
