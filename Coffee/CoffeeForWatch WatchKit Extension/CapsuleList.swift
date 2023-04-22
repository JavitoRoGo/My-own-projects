//
//  CapsuleList.swift
//  CoffeeForWatch WatchKit Extension
//
//  Created by Javier Rodríguez Gómez on 9/3/22.
//

import SwiftUI

struct CapsuleList: View {
    @EnvironmentObject var model: CapsuleModel
    var list: [CoffeCapsule] {
        model.capsules.filter( { $0.isRecent } )
    }
    
    var body: some View {
        List(list) { capsule in
            NavigationLink(destination: CapsuleDetail(capsule: capsule)) {
                CapsuleRow(capsule: capsule)
            }
        }
    }
}

struct CapsuleList_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleList()
            .environmentObject(CapsuleModel())
    }
}
