//
//  AllListedView.swift
//  MyRingsWithCD
//
//  Created by Javier Rodríguez Gómez on 16/12/22.
//

import SwiftUI

struct AllListedView: View {
    @EnvironmentObject var model: MyViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)]) var ringsCD: FetchedResults<RingEntity>
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(ringsCD) { ring in
                    NavigationLink(destination: EditView(ring: ring)) {
                        HStack {
                            Text(ring.date.formatted(date: .numeric, time: .omitted))
                            Spacer()
                            Text("\(ring.movement)").foregroundColor(.pink)
                            Text("\(ring.exercise)").foregroundColor(.green)
                            Text("\(ring.standUp)").foregroundColor(.blue)
                            Circle()
                                .fill(ring.isTraining ? (ring.toTrain?.trainingType == .toRun ? .orange : .green) : .clear)
                                .frame(width: 10)
                        }
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("\(ringsCD.count) registros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAlert = true
                    } label: {
                        Label("Borrar todo", systemImage: "trash")
                    }
                    .disabled(ringsCD.isEmpty)
                }
            }
            .alert("Estás a punto de borrar todos los datos.\n¿Estás seguro?", isPresented: $showingAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Borrar", role: .destructive) {
                    ringsCD.forEach { ring in
                        moc.delete(ring)
                    }
                    try? moc.save()
                    dismiss()
                }
            } message: {
                Text("Esta acción no podrá deshacerse.")
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let ring = ringsCD[index]
            moc.delete(ring)
            try? moc.save()
        }
    }
}

struct AllListedView_Previews: PreviewProvider {
    static var previews: some View {
        AllListedView()
            .environmentObject(MyViewModel())
    }
}
