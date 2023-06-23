//
//  Persistence.swift
//  VarianteTutorialSwiftUI
//
//  Created by Javier Rodríguez Gómez on 18/6/23.
//

import Foundation

final class Persistence {
    static let shared = Persistence()
    
    private init() { }
    
    let url = URL(string: "https://acoding.academy/testData/EmpleadosData.json")!
    
    func loadEmpleados() async throws -> [Empleado] {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badURL) }
        return try JSONDecoder().decode([Empleado].self, from: data)
    }
}
