//
//  EmpleadoCell.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 19/6/23.
//

import SwiftUI

struct EmpleadoCell: View {
    let empleado: Empleado
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(empleado.lastName), \(empleado.firstName)")
                    .font(.headline)
                Text(empleado.email)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(empleado.department.rawValue)
                    .padding(.top, 5)
            }
            Spacer()
            AsyncImage(url: empleado.avatar) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .background(Color(white: 0.9))
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }
        }
    }
}

struct EmpleadoCell_Previews: PreviewProvider {
    static var previews: some View {
        EmpleadoCell(empleado: .test)
    }
}
