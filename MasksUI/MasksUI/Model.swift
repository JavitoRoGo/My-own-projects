//
//  Model.swift
//  MasksUI
//
//  Created by Javier Rodríguez Gómez on 8/12/21.
//

import Foundation
import SwiftUI

// MARK: - Data structure

struct Masks: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var owner: Owner
    var washes: [Int]
    var dates: [String]
    var image: String
    var isActive: Bool
    
    static let dataTest = [Masks(id: 1, name: "Prueba", owner: .yago, washes: [1,2], dates: ["fecha1", "fecha2"], image: "", isActive: true)]
}

enum Owner: String, Codable, CaseIterable, Identifiable {
    case javi = "Javi"
    case aurora = "Aurora"
    case lucas = "Lucas"
    case yago = "Yago"
    
    var id: String { rawValue }
}

// MARK: - Model data

final class MasksModel: ObservableObject {
    @Published var masks: [Masks] {
        didSet {
            inactives = masks.filter { $0.isActive == false }.count
            saveToJson()
        }
    }
    var inactives: Int
    
    init() {
        guard var url = Bundle.main.url(forResource: "MASKS", withExtension: "json"),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                  masks = Masks.dataTest
                  inactives = 0
                  return
              }
        let file = documents.appendingPathComponent("MASKS").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
            print("Carga inicial desde archivo\n" + file.absoluteString)
        } else {
            print("Carga inicial desde Bundle")
        }
        
        do {
            inactives = 0
            let json = try Data(contentsOf: url)
            masks = try JSONDecoder().decode([Masks].self, from: json)
            inactives = masks.filter { $0.isActive == false }.count
        } catch {
            masks = Masks.dataTest
            inactives = 0
            print("Error en la carga: \(error)")
        }
    }
    
    func saveToJson() {
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentPath.appendingPathComponent("MASKS.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(masks)
            try data.write(to: fileURL)
            print("Grabación correcta\n" + fileURL.absoluteString)
        } catch {
            print("Error en la grabación: \(error)")
        }
    }
    
    func masksPerOwner(owner: Owner) -> Int {
        var num = 0
        for mask in masks where mask.owner == owner {
            num += 1
        }
        return num
    }
    
    func addNewWash(_ mask: Masks, _ date: Date) {
        let index = masks.firstIndex(of: mask)!
        let num = masks[index].washes.count + 1
        masks[index].washes.append(num)
        masks[index].dates.append(dateFormatter(date))
    }
    
}

func dateFormatter(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.locale = Locale(identifier: "fr_FR")
    let string = formatter.string(from: date)
    return string
}
