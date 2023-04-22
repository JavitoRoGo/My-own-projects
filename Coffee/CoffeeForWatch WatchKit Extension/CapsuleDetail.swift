//
//  CapsuleDetail.swift
//  CoffeeForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 9/3/22.
//

import SwiftUI

struct CapsuleDetail: View {
    @EnvironmentObject var model: CapsuleModel
    let capsule: CoffeCapsule
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
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 2)
                }
                .shadow(color: .gray, radius: 7)
            
            VStack {
                    Text("Acerca de \(capsule.name):")
                        .font(.title3)
                    .padding(.bottom, 8)
                HStack {
                    Text("Intensidad: \(capsule.intensity)")
                    Spacer()
                    Text("Precio: " + priceFormatter.string(from: NSNumber(value: capsule.price))!)
                }
            }
            
            Divider()
            Text("\(capsule.totalAmount) cápsulas - " +
                 priceFormatter.string(from: NSNumber(value: model.totalCapsulePrice(capsule)))!)
                .font(.title2)
        }
    }
}

struct CapsuleDetail_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleDetail(capsule: CoffeCapsule.testData[0])
            .environmentObject(CapsuleModel())
    }
}
