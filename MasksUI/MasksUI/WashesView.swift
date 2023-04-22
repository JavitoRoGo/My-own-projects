//
//  WashesView.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 9/12/21.
//

import SwiftUI

struct WashesView: View {
    @EnvironmentObject var model: MasksModel
    @Binding var mask: Masks
    @Binding var isActive: Bool
    @State private var showingDatePicker = false
    
    var body: some View {
        List {
            Toggle(isOn: $isActive, label: {
                Text("Mascarilla en uso")
            })
            ForEach(mask.dates.reversed(), id: \.self) { date in
                let indexData = mask.dates.firstIndex(of: date)! + 1
                HStack {
                    Text("\(indexData)")
                    Spacer()
                    Text(date)
                }
                .font(.title2)
                .foregroundColor(isActive ? .primary : .secondary)
            }
        }
        .navigationTitle(mask.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if mask.isActive {
                Button {
                    showingDatePicker.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            NewWash(mask: $mask)
        }
    }
}

struct WashesView_Previews: PreviewProvider {
    static var previews: some View {
        WashesView(mask: .constant(MasksModel().masks[0]), isActive: .constant(true))
            .environmentObject(MasksModel())
    }
}
