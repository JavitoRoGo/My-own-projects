//
//  ContentView.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 16/2/22.
//

import SwiftUI

let maxE = 113
let maxQ = 59

struct ContentView: View {
    @EnvironmentObject var model: MyDatesViewModel
    @State private var maxEvent: Int = 0
    @State private var maxQuery: Int = 0
    
    @State private var showingGraph = false
    @State private var showingAlert = false
    
    @State private var startEffect = false
    @State private var finishEffect = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(LocalizedStringKey("Time lapse")) {
                        HStack {
                            Text(LocalizedStringKey("Since last event"))
                            Spacer()
                            Text(LocalizedStringKey("\(model.myDates.sinceLastEvent) days"))
                        }
                        HStack {
                            Text(LocalizedStringKey("Since last query"))
                            Spacer()
                            Text(LocalizedStringKey("\(model.myDates.sinceLastQuery) days"))
                        }
                    }
                    
                    Section(LocalizedStringKey("Max time")) {
                        HStack {
                            Text(LocalizedStringKey("Last event"))
                            Spacer()
                            Text(LocalizedStringKey("\(maxEvent) days"))
                        }
                        HStack {
                            Text(LocalizedStringKey("Last query"))
                            Spacer()
                            Text(LocalizedStringKey("\(maxQuery) days"))
                        }
                    }
                    
                    Section(LocalizedStringKey("Last events")) {
                        HStack {
                            Text(LocalizedStringKey("Event"))
                            Spacer()
                            DatePicker(LocalizedStringKey("Last event"), selection: $model.myDates.lastEventDateModel, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                        HStack {
                            Text(LocalizedStringKey("Query"))
                            Spacer()
                            DatePicker(LocalizedStringKey("Last query"), selection: $model.myDates.lastQueryDateModel, in: ...Date.now, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                    }
                    
                    Section(LocalizedStringKey("\(model.myDates.listOfEvents.count) Events")) {
                        NavigationLink(destination: EventList()) {
                            Text(LocalizedStringKey("Event list"))
                        }
                        .disabled(model.myDates.listOfEvents.isEmpty)
                    }
                }
                
                EmitterView()
                    .scaleEffect(startEffect ? 1 : 0, anchor: .top)
                    .opacity(startEffect && !finishEffect ? 1 : 0)
                    .offset(y: startEffect ? 0 : getRect().height / 2)
                    .ignoresSafeArea()
            }
            .navigationTitle("Time Counter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingGraph = true
                    } label: {
                        Image(systemName: "chart.bar.xaxis")
                    }
                    .disabled(model.myDates.listOfEvents.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedStringKey("Add")) {
                        model.myDates.listOfEvents.insert(model.myDates.lastEventDateModel, at: 0)
                        maxEvent = model.myDates.lastEventMaxCalc()
                        maxQuery = model.myDates.lastQueryMaxCalc()
                        
                        showingAlert = true
                    }
                }
            }
            .alert(LocalizedStringKey("Date added correctly."), isPresented: $showingAlert) {
                Button("OK") {
                    showingAlert = false
                    doAnimation()
                }
            }
            .sheet(isPresented: $showingGraph) {
                NavigationStack {
                    DatesChart()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Back") {
                                    showingGraph = false
                                }
                            }
                        }
                }
            }
            .onAppear {
                maxEvent = model.myDates.lastEventMaxCalc()
                maxQuery = model.myDates.lastQueryMaxCalc()
            }
        }
    }
    
    func doAnimation() {
        withAnimation(.spring()) {
            startEffect = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeIn(duration: 1.5)) {
                finishEffect = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                finishEffect = false
                startEffect = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MyDatesViewModel())
            .environment(\.locale, .init(identifier: "en-GB"))
        ContentView()
            .environmentObject(MyDatesViewModel())
            .environment(\.locale, .init(identifier: "es"))
    }
}
