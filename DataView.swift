
import SwiftUI

struct TransportEmission {
    let name: String
    let emission: Double
}

struct TransportRoadspace{
    let name: String
    let roadspace: Double
}

struct TransportTime{
    let name: String
    let time: Double
}

struct modeOfTransport: Codable {
    var length: Double
    var width: Double
    var speed: Double
    var capacity: Int
    var emission: Double
}

let walk = modeOfTransport(length: 0.4, width: 0.7, speed: 5, capacity: 1, emission: 3.5)
let bike = modeOfTransport(length: 0.5, width: 1.2, speed: 15, capacity: 1, emission: 18)
let car = modeOfTransport(length: 4.5, width: 2.5, speed: 22.46, capacity: 1, emission: 644)
let jeep = modeOfTransport(length: 11, width: 2.5, speed: 9.4, capacity: 18, emission: 114)
let bus = modeOfTransport(length: 8.7, width: 2.5, speed: 12.2, capacity: 50, emission: 48.4)



struct DataView: View {
    var simulationData: [(simulationID: Int, walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int)]
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var commuterAllocator = CommuterAllocator()
    var body: some View {
        GeometryReader{geometry in
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
                    
                    Text("Simulation Data")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(Color(hex: 0x050505))
                    
                    let adaptiveColumn = [GridItem(.adaptive(minimum: 400))]
                    let halfAdaptiveColumn = [GridItem(.adaptive(minimum: 200))]
                    let thirdAdaptiveColumn = [GridItem(.adaptive(minimum: 300))]

                    LazyVGrid(columns: halfAdaptiveColumn , spacing: 10) { 
                        ForEach(commuterData(), id: \.0) { type, count in
                            CommuterInfoView(commuterType: type, count: count)
                        }
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: stripeHeight, style: .continuous))
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: "figure.walk")
                                    .font(.subheadline)
                                Image(systemName: "bicycle")
                                    .font(.subheadline)
                                Image(systemName: "car")
                                    .font(.subheadline)
                                Image(systemName: "truck.box.fill")
                                    .font(.subheadline)
                                Image(systemName: "bus")
                                    .font(.subheadline)
                                Text("Total")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            Spacer()
                            HStack {
                                Text("\(calculateTotalCommuters())")
                                    .font(.system(size: 48))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                        }
                        .padding()
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
            
 
                    }
                    .foregroundColor(Color(hex: 0xF5F5F5))
                    .padding()
                    .padding(.bottom, -32)
                    .frame(maxWidth: geometry.size.width, alignment: .leading)
                    
                    LazyVGrid(columns: adaptiveColumn, spacing: 10) {
                        VStack(alignment: .leading) {
                            let transportTypesWithEmissions = calculateTotalEmissions()
                            EmissionChartView(transportTypes: transportTypesWithEmissions, simulationData: simulationData.last)
                                .padding()
                                .frame(height: 400, alignment: .leading)
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
                        }
                        
                        VStack(alignment: .leading) {
                            let transportTypesWithRoadspace = calculateTotalRoadspace()
                            RoadspaceChartView(transportTypes: transportTypesWithRoadspace, simulationData: simulationData.last)
                                .padding()
                                .frame(height: 400, alignment: .leading)
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
                        }
                        VStack(alignment: .leading) {
                            AvgTimeView(simulationData: simulationData.last)
                                .padding()
                                .frame(height: 400, alignment: .leading)
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
                                
                        }
                    }
                    .padding()
                    .padding(.bottom, -32)
                    .frame(maxWidth: geometry.size.width, alignment: .leading)
                    
                    LazyVGrid(columns: thirdAdaptiveColumn , spacing: 10) {
                        SDG9View()
                            .padding()
                            .frame(height: 240, alignment: .center)
                            .background(Color(hex: 0xF36E24))
                            .cornerRadius(16)
                        SDG11View()
                            .padding()
                            .frame(height: 240, alignment: .leading)
                            .background(Color(hex: 0xF99D25))
                            .cornerRadius(16)
                        SDG13View()
                            .padding()
                            .frame(height: 240, alignment: .leading)
                            .background(Color(hex: 0x48773C))
                            .cornerRadius(16)
                        LogoView()
                            .padding()
                            .frame(height: 240, alignment: .leading)
                            .background(Color.gray.opacity(0.14))
                            .cornerRadius(16)
                    }
                    .padding()
                    .padding(.bottom, -32)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(sourceButtons(), id: \.0) { label, url in
                            SourceButton(label: label, url: url)
                        }
                    }
                    .foregroundColor(Color(hex: 0xf5f5f5))
                    .padding(.horizontal)
                    .padding()
                }
                .padding()
                .frame(maxHeight: .infinity)
            }
        }
        .foregroundColor(Color(hex: 0x020202))
        .background(Color(hex: 0xf5f5f5))
    }
    private func sourceButtons() -> [(String, String)] {
        [
            ("Source 1", "https://hal.science/hal-03543183/document#:~:text=2.6%2F%20Food%20to%20Foot%20carbon%20emissions%20per%20unit%20length&text=h%2Fkm%20for%20Walking%20and,range%20from%206%20to%2050\n"),
            ("Source 2", "https://www.adb.org/sites/default/files/linked-documents/52220-001-cca.pdf\n"),
            ("Source 3", "https://unbox.ph/news/mmda-edsa-average-speed-better-than-pre-pandemic-times/"),
            ("Source 4", "https://openjicareport.jica.go.jp/pdf/11580552_02.pdf"),
            ("Source 5", "http://epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle")
        ]
    }
    private func commuterData() -> [(String, Int)] {
        [
            ("Walk", simulationData.last?.walkCount ?? 0),
            ("Bike", simulationData.last?.bikeCount ?? 0),
            ("Car", simulationData.last?.carCount ?? 0),
            ("Jeep", simulationData.last?.jeepCount ?? 0),
            ("Bus", simulationData.last?.busCount ?? 0)
        ]
    }
    func calculateTotalEmissions() -> [TransportEmission] {
        guard let lastData = simulationData.last else { return [] }
        
        let walkEmission = Double(lastData.walkCount) * walk.emission
        let bikeEmission = Double(lastData.bikeCount) * bike.emission
        let carEmission = Double(lastData.carCount) * car.emission
        let jeepEmission = Double(lastData.jeepCount) * jeep.emission
        let busEmission = Double(lastData.busCount) * bus.emission
        
        return [
            TransportEmission(name: "Walk", emission: walkEmission),
            TransportEmission(name: "Bike", emission: bikeEmission),
            TransportEmission(name: "Car", emission: carEmission),
            TransportEmission(name: "Jeep", emission: jeepEmission),
            TransportEmission(name: "Bus", emission: busEmission)
        ]
    }
    func calculateTotalCommuters() -> Int {
        guard let lastData = simulationData.last else { return 0 }
        
        return lastData.walkCount + lastData.bikeCount + lastData.carCount + lastData.jeepCount + lastData.busCount

    }
    func calculateTotalRoadspace() -> [TransportRoadspace] {
        guard let lastData = simulationData.last else { return [] }
        let adjustedJeepCount = Int(ceil(Double(lastData.jeepCount) / Double(18)))
        let adjustedBusCount = Int(ceil(Double(lastData.busCount) / Double(50)))
        let walkRoadspace = Double(lastData.walkCount) * walk.width * walk.length
        let bikeRoadspace = Double(lastData.bikeCount) * bike.width * bike.length
        let carRoadspace = Double(lastData.carCount) * car.width * car.length
        let jeepRoadspace = Double(adjustedJeepCount) * jeep.width * jeep.length
        let busRoadspace = Double(adjustedBusCount) * bus.width * bus.length
        
        return [
            TransportRoadspace(name: "Walk", roadspace: walkRoadspace),
            TransportRoadspace(name: "Bike", roadspace: bikeRoadspace),
            TransportRoadspace(name: "Car", roadspace: carRoadspace),
            TransportRoadspace(name: "Jeep", roadspace: jeepRoadspace),
            TransportRoadspace(name: "Bus", roadspace: busRoadspace)
        ]
    }
    
    func calculateTime() -> [TransportTime] {
        return [
            TransportTime(name: "Walk", time: walk.speed),
            TransportTime(name: "Bike", time: bike.speed),
            TransportTime(name: "Car", time: car.speed),
            TransportTime(name: "Jeep", time: jeep.speed),
            TransportTime(name: "Bus", time: bus.speed)
        ]
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(simulationData: simulationData)
    }
}
struct CombinedView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedView()
        
    }
}
