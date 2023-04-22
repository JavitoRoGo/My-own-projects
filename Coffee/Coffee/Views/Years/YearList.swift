//
//  YearList.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 20/12/21.
//

import SwiftUI

struct YearList: View {
    @EnvironmentObject var model: CapsuleModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text(priceFormatter.string(from: NSNumber(value: model.totalPrice()))!)
                        Spacer()
                        Text(String(model.totalNum()))
                    }
                }
                Section("Datos por año") {
                    ForEach(Year.allCases.reversed()) { year in
                        HStack {
                            Text(String(year.rawValue))
                            Spacer()
                            Text(model.pricePerYear(year: year), format: .currency(code: "eur"))
                            Spacer()
                            Text(String(model.numberPerYear(year: year)))
                        }
                    }
                }
            }
            .navigationTitle("Años")
            #if os(macOS)
            List {
                Section {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text(priceFormatter.string(from: NSNumber(value: model.totalPrice()))!)
                        Spacer()
                        Text(String(model.totalNum()))
                    }
                    .font(.title)
                }
                Section("Datos por año") {
                    ForEach(Year.allCases.reversed()) { year in
                        HStack {
                            Text(String(year.rawValue))
                            Spacer()
                            Text(model.pricePerYear(year: year), format: .currency(code: "eur"))
                            Spacer()
                            Text(String(model.numberPerYear(year: year)))
                        }
                    }
                    .font(.title2)
                    .padding()
                }
            }
            .listStyle(.bordered(alternatesRowBackgrounds: true))
            #endif
        }
    }
}

struct YearList_Previews: PreviewProvider {
    static var previews: some View {
        YearList()
            .environmentObject(CapsuleModel())
    }
}
