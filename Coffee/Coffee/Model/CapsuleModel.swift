//
//  CapsuleModel.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 18/12/21.
//

import Foundation

struct CoffeCapsule: Codable, Identifiable, Equatable, Hashable {
    var id: String { name }
    let name: String
    let image: String
    let intensity: Int
    var price: Double
    var isRecent: Bool
    var amount: [Amount]
    var totalAmount: Int {
        var sum = 0
        for amount in amount {
            sum += amount.number
        }
        return sum
    }
    
    struct Amount: Codable, Equatable, Hashable {
        var number: Int
        var machine: Machines
        var year: Year
    }
    
    static let testData = [CoffeCapsule(name: "Prueba1", image: "unknown", intensity: 5, price: 0.35, isRecent: true, amount: [CoffeCapsule.Amount(number: 10, machine: .essenzaMini, year: .year2021)]), CoffeCapsule(name: "Prueba2", image: "unknown", intensity: 5, price: 0.35, isRecent: true, amount: [CoffeCapsule.Amount(number: 20, machine: .pixie, year: .year2020)]), CoffeCapsule(name: "Prueba3", image: "unknown", intensity: 5, price: 0.35, isRecent: false, amount: [CoffeCapsule.Amount(number: 30, machine: .inissia, year: .year2019)])]
}

enum Year: Int, Codable, CaseIterable, Identifiable {
    case year2015 = 2015
    case year2016 = 2016
    case year2017 = 2017
    case year2018 = 2018
    case year2019 = 2019
    case year2020 = 2020
    case year2021 = 2021
    case year2022 = 2022
    
    var id: Int { rawValue }
}

class CapsuleModel: ObservableObject {
    @Published var capsules: [CoffeCapsule] {
        didSet {
            saveToJson()
        }
    }
    
    init() {
        guard var url = Bundle.main.url(forResource: "COFFEE", withExtension: ".json"),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                  capsules = CoffeCapsule.testData
                  return
              }
        
        let file = documents.appendingPathComponent("COFFEE").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
            print("Carga inicial de cápsulas desde archivo\n" + file.absoluteString)
        } else {
            print("Carga inicial de cápsulas desde Bundle")
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            capsules = try JSONDecoder().decode([CoffeCapsule].self, from: jsonData)
        } catch {
            capsules = CoffeCapsule.testData
            print("Error en la carga: \(error)")
        }
    }
    
    func saveToJson() {
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentPath.appendingPathComponent("COFFEE.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(capsules)
            try data.write(to: fileURL)
            print("Grabación correcta\n" + fileURL.absoluteString)
        } catch {
            print("Error en la grabación: \(error)")
        }
    }
    
    func totalCapsulePrice(_ capsule: CoffeCapsule) -> Double {
        let num = Double(capsule.totalAmount)
        return num * capsule.price
    }
    
    func numberPerYear(_ capsule: CoffeCapsule, year: Year) -> Int {
        var sum = 0
        for amount in capsule.amount where amount.year == year {
            sum += amount.number
        }
        return sum
    }
    
    func numberPerYear(year: Year) -> Int {
        var sum = 0
        for capsule in capsules {
            for amount in capsule.amount where amount.year == year {
                sum += amount.number
            }
        }
        return sum
    }
    
    func pricePerYear(_ capsule: CoffeCapsule, year: Year) -> Double {
        let num = Double(numberPerYear(capsule, year: year))
        return num * capsule.price
    }
    
    func pricePerYear(year: Year) -> Double {
        var sum = 0.0
        for capsule in capsules {
            for amount in capsule.amount where amount.year == year {
                sum += (Double(amount.number) * capsule.price)
            }
        }
        return sum
    }
    
    func numberPerMachine(_ capsule: CoffeCapsule, machine: Machines) -> Int {
        var sum = 0
        for amount in capsule.amount where amount.machine == machine {
            sum += amount.number
        }
        return sum
    }
    
    func totalNum() -> Int {
        var sum = 0
        for year in Year.allCases {
            sum += numberPerYear(year: year)
        }
        return sum
    }
    
    func totalPrice() -> Double {
        var sum = 0.0
        for year in Year.allCases {
            sum += pricePerYear(year: year)
        }
        return sum
    }
}

let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.init(identifier: "fr_FR")
    formatter.numberStyle = .currency
    return formatter
}()
