//
//  EmpleadoDetail.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 19/6/23.
//

import SwiftUI

struct EmpleadoDetail: View {
    let empleado: Empleado
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("First name")
                        .bold()
                    Text(empleado.firstName)
                }
                VStack(alignment: .leading) {
                    Text("Last name")
                        .bold()
                    Text(empleado.lastName)
                }
                VStack(alignment: .leading) {
                    Text("Email")
                        .bold()
                    Text(empleado.email)
                }
                VStack(alignment: .leading) {
                    Text("Department")
                        .bold()
                    Text(empleado.department.rawValue)
                }
            } header: {
                Text("Datos personales")
            }
        }
        .navigationTitle("Detalle de empleado")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmpleadoDetail_Previews: PreviewProvider {
    static var previews: some View {
        EmpleadoDetail(empleado: .test)
    }
}
