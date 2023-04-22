//
//  MachineModel.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 18/12/21.
//

import Foundation

struct CoffeeMachine: Codable, Identifiable, Equatable {
    var id: String { name }
    var name: String
    var image: String
    var color: String
    var purchasingDate: String
    var price: Double
    var machine: Machines
}

enum Machines: String, Codable, CaseIterable, Identifiable {
    case inissia = "Inissia"
    case pixie = "Pixie"
    case essenzaMini = "Essenza Mini"
    
    var id: String { rawValue }
}

extension CoffeeMachine {
    static let example = CoffeeMachine(name: "Cafetera de prueba", image: "unknown", color: "Multicolor", purchasingDate: "01/01/2000", price: 50, machine: .inissia)
}


final class MachineModel: ObservableObject {
    @Published var machines: [CoffeeMachine] {
        didSet {
            saveToJson()
        }
    }
    
    init() {
        guard var url = Bundle.main.url(forResource: "MACHINES", withExtension: "json"),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                  machines = [CoffeeMachine(name: "Cafetera de prueba", image: "unknown", color: "Multicolor", purchasingDate: "01/01/2000", price: 50, machine: .inissia)]
                  return
              }
        
        let file = documents.appendingPathComponent("MACHINES").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
            print("Carga inicial de máquinas desde archivo\n" + file.absoluteString)
        } else {
            print("Carga inicial de máquinas desde Bundle")
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            machines = try JSONDecoder().decode([CoffeeMachine].self, from: jsonData)
        } catch {
            machines = [CoffeeMachine(name: "Cafetera de prueba", image: "unknown", color: "Multicolor", purchasingDate: "01/01/2000", price: 50, machine: .inissia)]
            print("Error en la carga: \(error)")
        }
    }
    
    func saveToJson() {
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentPath.appendingPathComponent("MACHINES.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(machines)
            try data.write(to: fileURL)
            print("Grabación correcta\n" + fileURL.absoluteString)
        } catch {
            print("Error en la grabación: \(error)")
        }
    }
    
    func totalAmount(_ machine: CoffeeMachine) -> Int {
        let capsules = CapsuleModel().capsules
        var sum = 0
        
        for capsule in capsules {
            for amount in capsule.amount where amount.machine == machine.machine {
                sum += amount.number
            }
        }
        return sum
    }
    
    func numPerYear(_ machine: CoffeeMachine, year: Year) -> Int {
        let capsules = CapsuleModel().capsules
        var sum = 0
        
        for capsule in capsules {
            for amount in capsule.amount where (amount.machine == machine.machine && amount.year == year) {
                sum += amount.number
            }
        }
        return sum
    }
    
    func pricePerYear(_ machine: CoffeeMachine, year: Year) -> Double {
        let capsules = CapsuleModel().capsules
        var price = 0.0
        
        for capsule in capsules {
            for amount in capsule.amount where (amount.machine == machine.machine && amount.year == year) {
                price += (Double(amount.number) * capsule.price)
            }
        }
        return price
    }
}
