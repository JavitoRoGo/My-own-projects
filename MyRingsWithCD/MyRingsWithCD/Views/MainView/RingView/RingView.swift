//
//  RingView.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import SwiftUI

struct RingView: View {
    let ring: RingEntity
    
    @State private var showingRing = true
    
    var body: some View {
        ZStack {
            ActivityRing(progress: showingRing ? Double(ring.movement) / 300.0 : 0,
                         ringRadius: 160,
                         thickness: 36)
            ActivityRing(progress: showingRing ? Double(ring.exercise) / 30.0 : 0,
                         ringRadius: 120,
                         thickness: 36,
                         startColor: Color(red: 146/255, green: 225/255, blue: 166/255),
                         endColor: .green)
            ActivityRing(progress: showingRing ? Double(ring.standUp) / 12.0 : 0,
                         ringRadius: 80,
                         thickness: 36,
                         startColor: Color(red: 118/255, green: 184/255, blue: 255/255),
                         endColor: .blue)
        }
        .frame(height: 350)
    }
}

//struct RingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RingView(ring: example)
//    }
//}
