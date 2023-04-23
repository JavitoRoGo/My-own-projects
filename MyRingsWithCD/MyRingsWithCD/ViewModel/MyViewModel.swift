//
//  MyViewModel.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 17/12/22.
//

import SwiftUI

//struct MyModel: Codable, Identifiable {
//    let id: UUID
//    let date: Date
//    let movement: Int
//    let exercise: Int
//    let standUp: Int
//    let isTraining: Bool
//    let training: Train?
//
//    static let example = [
//        MyModel(id: UUID(), date: Date.distantFuture, movement: 444, exercise: 44, standUp: 20, isTraining: true, training: Train.example),
//        MyModel(id: UUID(), date: Date.distantFuture, movement: 11, exercise: 1, standUp: 1, isTraining: false, training: nil)
//    ]
//}

//struct Train: Codable {
//    let type: TrainingType
//    let duration: TimeInterval
//    let lenght: Double
//    let calories: Int
//    let meanHR: Int
//
//    var velocity: Double {
//        if duration == 0 {
//            return 0.0
//        }
//        return lenght / duration * 60
//    }
//
//    static let example = Train(type: .toRun, duration: 180, lenght: 5.5, calories: 275, meanHR: 159)
//}


final class MyViewModel: ObservableObject {
//    var datas: [MyModel]
//    init() {
//        guard var url = Bundle.main.url(forResource: "MYRINGDATA.json", withExtension: nil),
//              let directory = getDocumentDirectory() else {
//            print("No se encuentra el archivo en el Bundle.")
//            datas = []
//            return
//        }
//        let fileDocuments = directory.appendingPathComponent("MYRINGDATA.json")
//        if FileManager.default.fileExists(atPath: fileDocuments.path) {
//            url = fileDocuments
//            print("Carga inicial de datos desde archivo:\n\(fileDocuments.absoluteString).")
//        } else {
//            print("Carga inicial de datos desde Bundle.")
//        }
//
//        do {
//            let jsonData = try Data(contentsOf: url)
//            let decodedData = try JSONDecoder().decode([MyModel].self, from: jsonData)
//            datas = decodedData
//            print("Datos cargados correctamente.")
//        } catch (let error){
//            print("Error al extraer los datos: \(error)")
//            datas = []
//        }
//    }
    
    
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
    func getDataForChart(tag: Int, rings: FetchedResults<RingEntity>) -> Array<RingEntity> {
        switch tag {
        case 1:
            return rings.prefix(30).sorted(by: { $0.date < $1.date })
        case 2:
            return rings.prefix(365).sorted(by: { $0.date < $1.date })
        case 3:
            return rings.sorted(by: { $0.date < $1.date })
        default:
            return rings.prefix(7).sorted(by: { $0.date < $1.date })
        }
    }
}

extension MyViewModel {
    // Extraer los datos de los entrenamientos
    
    func runningDates(from rings: FetchedResults<RingEntity>) -> [Date] {
        var array = [Date]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toRun {
                array.insert(ring.date, at: 0)
            }
        }
        return array
    }
    func walkingDates(from rings: FetchedResults<RingEntity>) -> [Date] {
        var array = [Date]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toWalk {
                array.insert(ring.date, at: 0)
            }
        }
        return array
    }
    
    func runningDuration(from rings: FetchedResults<RingEntity>) -> [Double] {
        var array = [Double]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toRun {
                array.insert(training.duration, at: 0)
            }
        }
        return array
    }
    func walkingDuration(from rings: FetchedResults<RingEntity>) -> [Double] {
        var array = [Double]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toWalk {
                array.insert(training.duration, at: 0)
            }
        }
        return array
    }
    
    func runningLength(from rings: FetchedResults<RingEntity>) -> [Double] {
        var array = [Double]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toRun {
                array.insert(training.length, at: 0)
            }
        }
        return array
    }
    func walkingLength(from rings: FetchedResults<RingEntity>) -> [Double] {
        var array = [Double]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toWalk {
                array.insert(training.length, at: 0)
            }
        }
        return array
    }
    
    func runningCals(from rings: FetchedResults<RingEntity>) ->[Double] {
        var array = [Int]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toRun {
                array.insert(Int(training.calories), at: 0)
            }
        }
        return array.map { Double($0) }
    }
    func walkingCals(from rings: FetchedResults<RingEntity>) ->[Double] {
        var array = [Int]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toWalk {
                array.insert(Int(training.calories), at: 0)
            }
        }
        return array.map { Double($0) }
    }
    
    func runningHR(from rings: FetchedResults<RingEntity>) ->[Double] {
        var array = [Int]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toRun {
                array.insert(Int(training.meanHR), at: 0)
            }
        }
        return array.map { Double($0) }
    }
    func walkingHR(from rings: FetchedResults<RingEntity>) ->[Double] {
        var array = [Int]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toWalk {
                array.insert(Int(training.meanHR), at: 0)
            }
        }
        return array.map { Double($0) }
    }
    
    func runningVelocity(from rings: FetchedResults<RingEntity>) -> [Double] {
        var array = [Double]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toRun {
                array.insert(Double(training.velocity), at: 0)
            }
        }
        return array
    }
    func walkingVelocity(from rings: FetchedResults<RingEntity>) -> [Double] {
        var array = [Double]()
        for ring in rings {
            if let training = ring.toTrain, training.trainingType == .toWalk {
                array.insert(Double(training.velocity), at: 0)
            }
        }
        return array
    }
    
    // Funciones para elegir los datos para la gráfica de entrenamientos
    func getRunningData(_ tag: Int, _ rings: FetchedResults<RingEntity>) -> [Double] {
        switch tag {
        case 1:
            return runningLength(from: rings)
        case 2:
            return runningVelocity(from: rings)
        case 3:
            return runningCals(from: rings)
        case 4:
            return runningHR(from: rings)
        default:
            return runningDuration(from: rings)
        }
    }
    func getWalkingData(_ tag: Int, _ rings: FetchedResults<RingEntity>) -> [Double] {
        switch tag {
        case 1:
            return walkingLength(from: rings)
        case 2:
            return walkingVelocity(from: rings)
        case 3:
            return walkingCals(from: rings)
        case 4:
            return walkingHR(from: rings)
        default:
            return walkingDuration(from: rings)
        }
    }
}
