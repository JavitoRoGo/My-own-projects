//
//  CapsuleDetail.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 17/12/21.
//

import SwiftUI

struct CapsuleDetail: View {
    @EnvironmentObject var model: CapsuleModel
    @Binding var capsule: CoffeCapsule
    @State private var showAddingData = false
    var image: Image {
        if capsule.image.isEmpty {
            return Image("unknown")
        } else {
            return Image(capsule.image)
        }
    }
    
    var body: some View {
        ScrollView {
            image
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(color: .gray, radius: 7)
                .opacity(capsule.isRecent ? 1 : 0.25)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Acerca de \(capsule.name):")
                        .font(.title2)
                    .padding(.bottom, 8)
                    Spacer()
                    Toggle(isOn: $capsule.isRecent) {
                        #if os(macOS)
                        Text("En circulación")
                        #endif
                    }
                }
                HStack {
                    Text("Intensidad: \(capsule.intensity)")
                    Spacer()
                    Text("Precio: " + priceFormatter.string(from: NSNumber(value: capsule.price))!)
                }
            }
            .padding([.top, .leading, .trailing])
            
            Divider()
            Text("\(capsule.totalAmount) cápsulas - " +
                 priceFormatter.string(from: NSNumber(value: model.totalCapsulePrice(capsule)))!)
                .font(.title)
                .padding(.vertical)
            CapsuleStatistic(capsule: capsule)
                .frame(width: 400, height: 400)
                .padding(.top, -20)
        }
        .navigationTitle(capsule.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            Button("Añadir datos") {
                showAddingData.toggle()
            }
            .disabled(!capsule.isRecent)
        }
        .sheet(isPresented: $showAddingData) {
            CapsuleNewData(capsule: $capsule)
        }
    }
}

struct CapsuleDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CapsuleDetail(capsule: .constant(CapsuleModel().capsules[0]))
                .environmentObject(CapsuleModel())
        }
    }
}
