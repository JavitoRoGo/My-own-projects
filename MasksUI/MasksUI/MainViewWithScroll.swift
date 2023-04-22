//
//  MainViewWithScroll.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 12/12/21.
//

import SwiftUI

struct MainViewWithScroll: View {
    @EnvironmentObject var model: MasksModel
    @State private var showInactive: Bool = false
    let owners = Owner.allCases
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showInactive, label: {
                    Text("Mostrar inactivas (\(model.inactives))")
                })
                ForEach(owners, id: \.self) { owner in
                    VStack(alignment: .leading) {
                        Text(owner.rawValue)
                            .font(.title2)
                        ScrollView(.horizontal) {
                            let filteredMasks: [Masks] = model.masks.filter {
                                $0.owner == owner && (showInactive || $0.isActive) }
                            
                            HStack {
                                ForEach(filteredMasks) { mask in
                                    let index = model.masks.firstIndex(of: mask)!
                                    NavigationLink(destination: WashesView(mask: $model.masks[index], isActive: $model.masks[index].isActive)) {
                                        VStack {
                                            Image(mask.image)
                                                .resizable()
                                                .frame(width: 180, height: 120)
                                                .clipShape(Ellipse())
                                                .overlay(Ellipse().stroke())
                                                .foregroundColor(.black)
                                                .opacity(mask.isActive ? 1 : 0.25)
                                            
                                            HStack {
                                                Spacer()
                                                VStack {
                                                    Text(mask.name)
                                                        .font(.title2)
                                                        .fontWeight(mask.isActive ? .bold : .thin)
                                                    Text("\(mask.washes.count) lavados")
                                                        .font(.headline)
                                                        .fontWeight(mask.isActive ? .light : .thin)
                                                }
                                                .foregroundColor(mask.isActive ? .black : .gray)
                                                
                                                Spacer()
                                                Image(systemName: mask.isActive ? "checkmark.square" : "xmark.square")
                                                    .foregroundColor(mask.isActive ? .green : .red)
                                                    .font(.title)
                                            }
                                        }
                                        .padding(20)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Propietarios")
        }
    }
}

struct MainViewWithScroll_Previews: PreviewProvider {
    static var previews: some View {
        MainViewWithScroll()
            .environmentObject(MasksModel())
    }
}
