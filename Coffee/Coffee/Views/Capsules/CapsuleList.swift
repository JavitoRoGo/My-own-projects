//
//  CapsuleList.swift
//  Coffee
//
//  Created by Javier Rodríguez Gómez on 17/12/21.
//

import SwiftUI

struct CapsuleList: View {
    @EnvironmentObject var model: CapsuleModel
    
    @State private var searchText = ""
    var searchResults: [CoffeCapsule] {
        if searchText.isEmpty {
            switch sortBy {
            case .name:
                return model.capsules.sorted { $0.name < $1.name }
            case .number:
                return model.capsules.sorted { $0.totalAmount > $1.totalAmount }
            }
        } else {
            switch sortBy {
            case .name:
                return model.capsules.filter { $0.name.lowercased().contains(searchText.lowercased()) }.sorted { $0.name < $1.name }
            case .number:
                return model.capsules.filter { $0.name.lowercased().contains(searchText.lowercased()) }.sorted { $0.totalAmount > $1.totalAmount }
            }
        }
    }
    @State private var showRecent = true
    @State private var showingAddCapsule = false
    
    enum SortType: String, CaseIterable, Identifiable {
        case name = "Por nombre"
        case number = "Por cantidad"
        var id: SortType { self }
    }
    @State private var sortBy: SortType = .name
    
    var body: some View {
        let filteredResults = searchResults.filter { !showRecent || $0.isRecent }
        
        NavigationView {
            List {
                Toggle(isOn: $showRecent) {
                    Text("Mostrar solo en circulación")
                }
                ForEach(filteredResults) { capsule in
                    let index = model.capsules.firstIndex(of: capsule) ?? 0
                    
                    NavigationLink(destination: CapsuleDetail(capsule: $model.capsules[index])) {
                        CapsuleRow(capsule: capsule)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Búsqueda por nombre")
            .navigationTitle("Cápsulas")
            .toolbar {
                HStack {
                    Menu {
                        Picker("Sort by", selection: $sortBy) {
                            ForEach(SortType.allCases) { sortCase in
                                Text(sortCase.rawValue).tag(sortCase)
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                    Button {
                        showingAddCapsule = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCapsule) {
                AddCapsule()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancelar", role: .cancel) {
                                showingAddCapsule = false
                            }
                        }
                    }
            }
        }
    }
}

struct CapsuleList_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleList()
            .environmentObject(CapsuleModel())
    }
}
