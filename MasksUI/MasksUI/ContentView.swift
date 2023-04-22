//
//  ContentView.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 13/12/21.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .maskList
    
    enum Tab {
        case maskList
        case viewWithScroll
    }
    
    var body: some View {
        TabView(selection: $selection) {
            MaskList()
                .tabItem {
                    Label("Mascarillas", systemImage: "list.bullet")
                }
                .tag(Tab.maskList)
            
            MainViewWithScroll()
                .tabItem {
                    Label("Propietarios", systemImage: "text.append")
                }
                .tag(Tab.viewWithScroll)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MasksModel())
    }
}
