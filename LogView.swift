import SwiftUI

enum SortingCriteria: String, CaseIterable {
    case emissions = "Emission"
    case avgtime = "Time"
    case roadspace = "Space"
    
}



struct LogView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCriteria: SortingCriteria = .avgtime
    @State private var selectedLogID: Int? = nil
    
    var sortedLogEntries: [(logID: Int, logTitle: String, emissions: Double, roadspace: Double, avgtime: Double)] {
        switch selectedCriteria {
        case .avgtime:
            print("\(logData.sorted(by: { $0.avgtime < $1.avgtime }))")
            return logData.sorted(by: { $0.avgtime < $1.avgtime })
        case .roadspace:
            print("\(logData.sorted(by: { $0.roadspace < $1.roadspace }))")
            return logData.sorted(by: { $0.roadspace < $1.roadspace })
        case .emissions:
            print("\(logData.sorted(by: { $0.emissions < $1.emissions }))")
            return logData.sorted(by: { $0.emissions < $1.emissions })
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .padding(20)
                        }
                    }
                    .padding(.top)
                    
                    Text("All Data")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(Color(hex: 0x050505))


                    VStack(spacing: 10) {
                        HStack(alignment: .center) {
                            ForEach(SortingCriteria.allCases, id: \.self) { criteria in
                                Button(action: {
                                    selectedCriteria = criteria
                                    print("\(sortedLogEntries)")
                                }) {
                                    Text(criteria.rawValue)
                                        .foregroundColor(selectedCriteria == criteria ? .white : Color(hex: 0x308966))
                                        .frame(maxWidth: geometry.size.width)
                                        .frame(height: 48)
                                        .padding(.horizontal)
                                        .background(selectedCriteria == criteria ? Color(hex: 0x308966) : Color.clear)
                                        .cornerRadius(24)
                                }
                            }
                        }
                        .frame(maxWidth: geometry.size.width)
                        .frame(alignment: .center)

                        
                        ForEach(sortedLogEntries, id: \.logID) { data in
                            let simulation = simulationData.first(where: { $0.simulationID == data.logID })
                            VStack(alignment: .leading) {
                                Text("\(data.logTitle)")
                                    .font(.headline)
                                Text("Commuters per Transport Type")
                                    .padding(.top)
                                HStack {
                                    if let simulation = simulation {
                                        VStack {
                                            Image(systemName: "figure.walk")
                                            Text("\(simulation.walkCount)")
                                        }
                                        .frame(maxWidth: geometry.size.width * 0.15)
                                        VStack {
                                            Image(systemName: "bicycle")
                                            Text("\(simulation.bikeCount)")
                                        }
                                        .frame(maxWidth: geometry.size.width * 0.15)
                                        VStack {
                                            Image(systemName: "car")
                                            Text("\(simulation.carCount)")
                                        }
                                        .frame(maxWidth: geometry.size.width * 0.15)
                                        VStack {
                                            Image(systemName: "truck.box.fill")
                                            Text("\(simulation.jeepCount)")
                                        }
                                        .frame(maxWidth: geometry.size.width * 0.15)
                                        VStack {
                                            Image(systemName: "bus")
                                            Text("\(simulation.busCount)")
                                        }
                                        .frame(maxWidth: geometry.size.width * 0.15)
                                    }
                                }
                                .padding(.vertical)
                                Text("Average Time")
                                Text("\(timeStringFrom(hours: data.avgtime))")
                                    .font(.system(size: 32))
                                    .fontWeight(.semibold)
                                Text("Total Roadspace")
                                Text("\(data.roadspace, specifier: "%.2f") sqm")
                                    .font(.system(size: 32))
                                    .fontWeight(.semibold)
                                Text("Total Emission")
                                Text("\(data.emissions, specifier: "%.2f") CO2 g/pkm")
                                    .font(.system(size: 32))
                                    .fontWeight(.semibold)
                                
                            }
                            
                            .padding()
                            .frame(maxWidth: geometry.size.width, alignment: .leading)
                            .cornerRadius(16)
                            .padding(.top, stripeHeight)
                            .foregroundColor(Color(hex: 0x1d3630))
                            .background {
                                ZStack(alignment: .top) {
                                    Rectangle()
                                        .opacity(0.2)
                                    Rectangle()
                                        .frame(maxHeight: stripeHeight)
                                }
                                .foregroundColor(Color(hex: 0x308966))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: stripeHeight, style: .continuous))
                            .onTapGesture {
                                selectedLogID = data.logID
                            }
                        }
                    }
                    .padding()
                }
                .padding()
                .frame(width: geometry.size.width)
                .frame(maxHeight: .infinity)
            }
        }
        .background(Color(hex: 0xf5f5f5))
        .sheet(item: $selectedLogID) { logID in // Present sheet when selectedLogID is set
                    if let simulation = simulationData.first(where: { $0.simulationID == logID }) {
                        DataView(simulationData: [(simulationID: simulation.simulationID, walkCount: simulation.walkCount, bikeCount: simulation.bikeCount, carCount: simulation.carCount, jeepCount: simulation.jeepCount, busCount: simulation.busCount)])
                    }
                }
    }
    private func timeStringFrom(hours: Double) -> String {
        let totalSeconds = Int(hours * 3600)
        let hoursComponent = totalSeconds / 3600
        let minutesComponent = (totalSeconds % 3600) / 60
        let secondsComponent = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hoursComponent, minutesComponent, secondsComponent)
    }
}
extension Int: Identifiable {
    public var id: Int {
        self
    }
}
struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()

    }
}
