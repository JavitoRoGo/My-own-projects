//
//  EmpleadosVM.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import SwiftUI

final class EmpleadosVM: ObservableObject {
    let persistence = Persistence.shared
    
    @Published var empleados: [Empleado] = []
    @Published var showAlert = false
    @Published var message = ""
    
    init() {
        Task { await getEmpleados() }
    }
    
    @MainActor func getEmpleados() async {
        do {
            empleados = try await persistence.loadEmpleados()
        } catch {
            message = error.localizedDescription
            showAlert.toggle()
        }
    }
}
