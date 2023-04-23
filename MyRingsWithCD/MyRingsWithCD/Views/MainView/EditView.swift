//
//  EditView.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var ringsCD: FetchedResults<RingEntity>
    
    let ring: RingEntity
    
    @State private var newDate: Date = .now
    @State private var newMovement: Int = 0
    @State private var newExercise: Int = 0
    @State private var newStandUp: Int = 0
    @State private var newIsTraining: Bool = false
    
    @State private var newTrainType: TrainingType = .toRun
    @State private var newDurationInHour: Int = 0
    @State private var newDurationInMinutes: Int = 0
    @State private var newDurationInSeconds: Int = 0
    @State private var newLength: Double = 0.0
    @State private var newCals: Int = 0
    @State private var newMeanHR: Int = 0
    var newDuration: Double {
        Double(newDurationInHour*60 + newDurationInMinutes) + (Double(newDurationInSeconds) / 60.0)
    }
    var velocity: Double {
        if newDuration == 0 {
            return 0.0
        }
        return newLength / newDuration * 60
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Fecha")
                        Spacer()
                        DatePicker("", selection: $newDate, in: ...Date(), displayedComponents: .date)
                    }
                    HStack {
                        Text("Movimiento")
                        Spacer()
                        TextField("kcal", value: $newMovement, format: .number)
                            .multilineTextAlignment(.trailing)
                    }
                    .foregroundColor(.pink)
                    HStack {
                        Text("Ejercicio")
                        Spacer()
                        TextField("minutos", value: $newExercise, format: .number)
                            .multilineTextAlignment(.trailing)
                    }
                    .foregroundColor(.green)
                    HStack {
                        Text("De pie")
                        Spacer()
                        TextField("horas", value: $newStandUp, format: .number)
                            .multilineTextAlignment(.trailing)
                    }
                    .foregroundColor(.blue)
                    Toggle(isOn: $newIsTraining) {
                        Text("Entrenamiento")
                    }
                }
                Section {
                    if newIsTraining {
                        Picker("Tipo", selection: $newTrainType) {
                            ForEach(TrainingType.allCases, id:\.self) {
                                Text($0.rawValue)
                            }
                        }
                        HStack {
                            Text("Tiempo")
                            Spacer()
                            HStack {
                                Picker("horas", selection: $newDurationInHour) {
                                    ForEach(0...2, id: \.self) {
                                        Text("\($0) h")
                                    }
                                }
                                .frame(width: 20)
                                Picker("minutos", selection: $newDurationInMinutes) {
                                    ForEach(0...59, id: \.self) {
                                        Text("\($0) m")
                                    }
                                }
                                Picker("segundos", selection: $newDurationInSeconds) {
                                    ForEach(0...59, id: \.self) {
                                        Text("\($0) s")
                                    }
                                }
                            }
                            .labelsHidden()
                        }
                        HStack {
                            Text("Distancia (km)")
                            Spacer()
                            TextField("km", value: $newLength, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Velocidad (km/h)")
                            Spacer()
                            Text(velocity, format: .number.precision(.fractionLength(2)))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Calorías (kcal)")
                            Spacer()
                            TextField("kcal", value: $newCals, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("FC media (lpm)")
                            Spacer()
                            TextField("lpm", value: $newMeanHR, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Modificar") {
                        editData()
                        dismiss()
                    }
                }
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        newDate = ring.date
        newMovement = Int(ring.movement)
        newExercise = Int(ring.exercise)
        newStandUp = Int(ring.standUp)
        newIsTraining = ring.isTraining
        
        if let training = ring.toTrain {
            newTrainType = training.trainingType
            newDurationInHour = Int(training.duration) / 60
            newDurationInMinutes = Int(training.duration) % 60
            newDurationInSeconds = Int(training.duration * 60) % 60
            newLength = training.length
            newCals = Int(training.calories)
            newMeanHR = Int(training.meanHR)
        }
    }
    
    func editData() {
        if let index = ringsCD.firstIndex(of: ring) {
            ringsCD[index].date = newDate
            ringsCD[index].movement = Int16(newMovement)
            ringsCD[index].exercise = Int16(newExercise)
            ringsCD[index].standUp = Int16(newStandUp)
            ringsCD[index].isTraining = newIsTraining
            if newIsTraining {
                if let _ = ringsCD[index].toTrain {
                    ringsCD[index].toTrain?.trainingType = newTrainType
                    ringsCD[index].toTrain?.duration = newDuration
                    ringsCD[index].toTrain?.length = newLength
                    ringsCD[index].toTrain?.calories = Int16(newCals)
                    ringsCD[index].toTrain?.meanHR = Int16(newMeanHR)
                } else {
                    let newTrain = TrainingEntity(context: moc)
                    newTrain.trainingType = newTrainType
                    newTrain.duration = newDuration
                    newTrain.length = newLength
                    newTrain.calories = Int16(newCals)
                    newTrain.meanHR = Int16(newMeanHR)
                    ringsCD[index].toTrain = newTrain
                }
            }
            try? moc.save()
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
