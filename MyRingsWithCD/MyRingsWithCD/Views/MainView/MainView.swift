//
//  MainView.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import SwiftUI

struct MainView: View {
//    @EnvironmentObject var model: MyViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var ringsCD: FetchedResults<RingEntity>
    
    @State private var showingAddNew = false
    @State private var number = 7
    
    var rings: Array<RingEntity> {
        ringsCD.prefix(number).sorted { $0.date > $1.date }
    }
    
    var body: some View {
        NavigationStack {
            if ringsCD.isEmpty {
                VStack(spacing: 100) {
                    VStack {
                        Text("Añade algunos datos para")
                        Text("comenzar a usar la app...")
                    }
                    .font(.title)
                    Button {
                        showingAddNew = true
                    } label: {
                        Text("Añadir")
                            .font(.largeTitle)
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                GeometryReader { geo in
                    VStack(alignment: .leading) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue.opacity(0.1))
                                .frame(height: 35)
                            HStack {
                                Text("Mostrando \(number) de \(ringsCD.count)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Stepper("Mostrar", value: $number, in: 1...ringsCD.count)
                                    .labelsHidden()
                            }
                            .padding(.horizontal)
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(rings) { ring in
                                    VStack {
                                        Text(ring.date.formatted(date: .complete, time: .omitted))
                                            .font(.title2)
                                        HStack {
                                            Image(systemName: "arrow.left")
                                                .opacity(ring.id == rings.first?.id ? 0 : 1)
                                            Spacer()
                                            Image(systemName: "arrow.right")
                                                .opacity(ring.id == rings.last?.id ? 0 : 1)
                                        }
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal)
                                        RingView(ring: ring)
                                        .padding()
                                        ListView(ring: ring)
                                    }
                                    .frame(width: geo.size.width)
                                }
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
//                            Button("Cargar") {
//                                loadData()
//                            }
                            NavigationLink(destination: AllListedView()) {
                                Label("Listado", systemImage: "list.bullet")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddNew = true
                        } label: {
                            Label("Nuevo", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNew) {
            AddNewView()
        }
        .onAppear {
            if ringsCD.count < 8 {
                number = ringsCD.count
            }
        }
    }
    
//    func loadData() {
//        model.datas.forEach { data in
//            let newRing = RingEntity(context: moc)
//            newRing.id = data.id
//            newRing.date = data.date
//            newRing.movement = Int16(data.movement)
//            newRing.exercise = Int16(data.exercise)
//            newRing.standUp = Int16(data.standUp)
//            newRing.isTraining = data.isTraining
//            if data.isTraining {
//                if let training = data.training {
//                    let newTrain = TrainingEntity(context: moc)
//                    newTrain.trainingType = training.type
//                    newTrain.duration = training.duration
//                    newTrain.length = training.lenght
//                    newTrain.calories = Int16(training.calories)
//                    newTrain.meanHR = Int16(training.meanHR)
//                    newRing.toTrain = newTrain
//                }
//            }
//            try? moc.save()
//        }
//    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MyViewModel())
    }
}
