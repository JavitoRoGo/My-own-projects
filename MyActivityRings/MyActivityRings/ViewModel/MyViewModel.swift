//
//  MyViewModel.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import SwiftUI

final class MyViewModel: ObservableObject {
    @Published var myRingsData: [MyModel] {
        didSet {
            saveToJson()
        }
    }
    
    init() {
        guard var url = Bundle.main.url(forResource: jsonFile, withExtension: nil),
              let directory = getDocumentDirectory() else {
            print("No se encuentra el archivo en el Bundle.")
            myRingsData = []
            return
        }
        let fileDocuments = directory.appendingPathComponent(jsonFile)
        if FileManager.default.fileExists(atPath: fileDocuments.path) {
            url = fileDocuments
            print("Carga inicial de datos desde archivo:\n\(fileDocuments.absoluteString).")
        } else {
            print("Carga inicial de datos desde Bundle.")
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([MyModel].self, from: jsonData)
            myRingsData = decodedData
            print("Datos cargados correctamente.")
        } catch (let error){
            print("Error al extraer los datos: \(error)")
            myRingsData = []
        }
    }
    
    func saveToJson() {
        guard let directory = getDocumentDirectory() else { return }
        let fileURL = directory.appendingPathComponent(jsonFile)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(myRingsData)
            try data.write(to: fileURL, options: .atomic)
            print("Grabación correcta")
            print(fileURL.absoluteString)
        } catch (let error){
            print("Error en la grabación \(error)")
        }
    }
    
    // FUNCIONES PARA LAS GRÁFICAS
    // Función para calcular Calendar.component
    func calcCalendarComponent(tag: Int) -> Calendar.Component {
        switch tag {
        case 1:
            return .day
        case 2:
            return .month
        case 3:
            return .year
        default:
            return .weekday
        }
    }
    
    // Función para obtener los datos de anillos a representar
    func getDataForChart(tag: Int) -> [MyModel] {
        switch tag {
        case 1:
            return myRingsData.prefix(30).sorted(by: { $0.date < $1.date })
        case 2:
            return myRingsData.prefix(365).sorted(by: { $0.date < $1.date })
        case 3:
            return myRingsData.sorted(by: { $0.date < $1.date })
        default:
            return myRingsData.prefix(7).sorted(by: { $0.date < $1.date })
        }
    }
}

extension MyViewModel {
    // Extraer los datos de los entrenamientos
    
    var runningDates: [Date] {
        var array = [Date]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(ring.date, at: 0)
            }
        }
        return array
    }
    var walkingDates: [Date] {
        var array = [Date]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(ring.date, at: 0)
            }
        }
        return array
    }
    
    var runningDuration: [Double] {
        var array = [Double]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.duration, at: 0)
            }
        }
        return array
    }
    var walkingDuration: [Double] {
        var array = [Double]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.duration, at: 0)
            }
        }
        return array
    }
    
    var runningLength: [Double] {
        var array = [Double]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.lenght, at: 0)
            }
        }
        return array
    }
    var walkingLength: [Double] {
        var array = [Double]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.lenght, at: 0)
            }
        }
        return array
    }
    
    var runningCals: [Double] {
        var array = [Int]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.calories, at: 0)
            }
        }
        return array.map { Double($0) }
    }
    var walkingCals: [Double] {
        var array = [Int]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.calories, at: 0)
            }
        }
        return array.map { Double($0) }
    }
    
    var runningHR: [Double] {
        var array = [Int]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.meanHR, at: 0)
            }
        }
        return array.map { Double($0) }
    }
    var walkingHR: [Double] {
        var array = [Int]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.meanHR, at: 0)
            }
        }
        return array.map { Double($0) }
    }
    
    var runningVelocity: [Double] {
        var array = [Double]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(Double(training.velocity), at: 0)
            }
        }
        return array
    }
    var walkingVelocity: [Double] {
        var array = [Double]()
        myRingsData.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(Double(training.velocity), at: 0)
            }
        }
        return array
    }
    
    // Funciones para elegir los datos para la gráfica de entrenamientos
    func getRunningData(_ tag: Int) -> [Double] {
        switch tag {
        case 1:
            return runningLength
        case 2:
            return runningVelocity
        case 3:
            return runningCals
        case 4:
            return runningHR
        default:
            return runningDuration
        }
    }
    func getWalkingData(_ tag: Int) -> [Double] {
        switch tag {
        case 1:
            return walkingLength
        case 2:
            return walkingVelocity
        case 3:
            return walkingCals
        case 4:
            return walkingHR
        default:
            return walkingDuration
        }
    }
}


let jsonFile = "MYRINGDATA.json"

func getDocumentDirectory() -> URL? {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path.first
}
