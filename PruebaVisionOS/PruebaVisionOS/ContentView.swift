//
//  ContentView.swift
//  PruebaVisionOS
//
//  Created by Javier Rodríguez Gómez on 23/6/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @StateObject var vm = EmpleadosVM()
    
    var body: some View {
        NavigationSplitView {
            List(vm.empleados) { empleado in
                NavigationLink(value: empleado) {
                    EmpleadoCell(empleado: empleado)
                }
            }
            .navigationDestination(for: Empleado.self) { empleado in
                EmpleadoDetail(empleado: empleado)
            }
            .navigationTitle("Empleados")
        } detail: {
            VStack {
                Text("Pulsa para ver el detalle")
            }
            .navigationTitle("Detalle")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
