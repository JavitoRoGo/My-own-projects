//
//  CapsuleRow.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 17/12/21.
//

import SwiftUI

struct CapsuleRow: View {
    @EnvironmentObject var model: CapsuleModel
    var capsule: CoffeCapsule
    var image: Image {
        if capsule.image.isEmpty {
            return Image("unknown")
        } else {
            return Image(capsule.image)
        }
    }
    
    var body: some View {
        HStack {
            image
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                .opacity(capsule.isRecent ? 1 : 0.25)
            VStack(alignment: .leading) {
                Text(capsule.name)
                    .font(.title3).bold()
                Text("\(capsule.totalAmount.formatted(.number.grouping(.never)))")
            }
            .foregroundColor(capsule.isRecent ? .primary : .secondary)
            .padding(.leading, 15)
            Spacer()
        }
    }
}

struct CapsuleRow_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleRow(capsule: CapsuleModel().capsules[0])
            .environmentObject(CapsuleModel())
            .previewLayout(.fixed(width: 400, height: 70))
    }
}
