//
//  Model.swift
//  Masks
//
//  Created by Javier Rodríguez Gómez on 15/8/21.
//

import UIKit
import FirebaseFirestore

// MARK: - Data structure

struct Masks: Codable {
    let name: String
    let owner: Owner
    var washes: [Int]
    var dates: [String]
    var image: String
    var isActive: Bool
    
    init() {
        name = ""
        owner = .aurora
        washes = []
        dates = []
        image = ""
        isActive = false
    }
    
    init(name: String, owner: Owner, washes: [Int], dates: [String], image: String, isActive: Bool) {
        self.name = name
        self.owner = owner
        self.washes = washes
        self.dates = dates
        self.image = image
        self.isActive = true
    }
}

enum Owner: String, Codable, CaseIterable {
    case javi = "Javi"
    case aurora = "Aurora"
    case lucas = "Lucas"
    case yago = "Yago"
}

// MARK: - Model data

struct MasksModel {
    var masks: [Masks] {
        didSet {
            saveToJson()
        }
    }
    
    // El código de este init está bien, pero no funciona porque no se ejecuta la descarga de datos a tiempo: el closure de db se ejecuta más tarde porque es un escpaing closure. Mejorarlo cuando sepa usar las operaciones asíncronas
    /*init() {
        masks = []
        var array = [Masks]()
        
        db.collection("masks").getDocuments() { (querySnapshot, error) in
            if let query = querySnapshot, error == nil {
                for document in query.documents {
                    if let newOwner = document.get("owner") as? String,
                       let newWashes = document.get("washes") as? [Int],
                       let newDates = document.get("dates") as? [String],
                       let newImage = document.get("image") as? String,
                       let newActive = document.get("active") as? Bool {
                        let newMask = Masks(name: document.documentID, owner: Owner.init(rawValue: newOwner)!, washes: newWashes, dates: newDates, image: newImage, isActive: newActive)
                        array.append(newMask)
                    }
                }
            }
        }
    
        masks = array
    }*/
    
    init() {
        guard var url = Bundle.main.url(forResource: "MASKS", withExtension: "json"),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                  masks = []
                  return
              }
        let file = documents.appendingPathComponent("MASKS").appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: file.path) {
            url = file
            print("Carga inicial desde archivo: \n" + file.absoluteString)
        } else {
            print("Carga inicial desde Bundle")
        }
        do {
            let json = try Data(contentsOf: url) //datos cargados en memoria
            masks = try JSONDecoder().decode([Masks].self, from: json) //extraer los datos
        } catch {
            print("Error en la carga \(error)")
            masks = []
        }
    }
    
    // Guardar los datos en JSON
    func saveToJson() {
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentPath.appendingPathComponent("MASKS.json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(masks)
            try data.write(to: fileURL)
            print("Grabación correcta")
            print(fileURL.absoluteString) //para obtener la ruta al archivo
        } catch {
            print("Error en la grabación \(error)")
        }
    }
    
    // Añadir nuevo lavado
    mutating func addNewWash(mask: Masks) {
        guard let index = masks.firstIndex(where: { $0.name == mask.name }) else { return }
        masks[index] = mask
    }
    
    // Modificar el estado de activación
    mutating func setIsActive(mask: Masks) {
        guard let index = masks.firstIndex(where: { $0.name == mask.name }) else { return }
        masks[index].isActive = mask.isActive
    }
    
    // Borrar los datos
    mutating func deleteWashes(mask: Masks, indexPath: IndexPath) {
        guard let index = masks.firstIndex(where: { $0.name == mask.name }),
              let index2 = masks[index].washes.firstIndex(where: { $0 == mask.washes.reversed()[indexPath.row] }) else { return }
        masks[index].washes.remove(at: index2)
        masks[index].dates.remove(at: index2)
    }
    
    
    // Número de elementos de la tabla principal (owners)
    func numberOfOwners() -> Int {
        Owner.allCases.count
    }
    
    // Título para cada celda de la tabla principal
    func titleForCells(indexPath: IndexPath) -> String {
        Owner.allCases[indexPath.row].rawValue
    }
    
    // Subtítulo para cada celda de la tabla principal (masks/owner)
    func subtitleForCells(indexPath: IndexPath) -> String {
        let owner = Owner.allCases[indexPath.row]
        var num = 0
        for mask in masks where mask.owner == owner {
            num += 1
        }
        return "\(num) mascarillas"
    }
    
    // Número de elementos para CollectionView (masks/owner)
    func numberOfMasks(owner: Owner) -> Int {
        let maskArray = masks.filter { $0.owner == owner }
        let num = maskArray.count
        return num
    }
    
    // Elementos a mostrar en CollectionView
    func queryMasks(owner: Owner, indexPath: IndexPath) -> Masks {
        let maskArray = masks.filter { $0.owner == owner }
        let mask = maskArray[indexPath.row]
        return mask
    }
    
    // Recuperar la portada
    func getMaskImage(imageName: String) -> UIImage {
        var imageToShow = UIImage()
        if let existingImage = UIImage(named: imageName) {
            imageToShow = existingImage
        } else {
            let documents = getDocumentsDirectory()
            let file = documents.appendingPathComponent(imageName).appendingPathExtension("jpg")
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    let imageData = try Data(contentsOf: file)
                    if let savedImage = UIImage(data: imageData) {
                        imageToShow = savedImage
                    }
                } catch {
                    print("Error al convertir la imagen: \(error)")
                }
            }
        }
        return imageToShow
    }
    
    // Elementos a mostrar en AppleWatch
    func queryMasks(owner: Owner) -> [Masks] {
        let maskArray = masks.filter { $0.owner == owner }
        return maskArray
    }
    
    // Número de elementos para tabla de detalle (washes)
    func numberOfWashes(mask: Masks) -> Int {
        mask.washes.count
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "fr_FR")
        let dateString = formatter.string(from: date)
        return dateString
    }
    
}

// Función para crear ruta y luego guardar los datos
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
