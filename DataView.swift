
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

struct EmissionChartView: View {
    var transportTypes: [TransportEmission]
    var simulationData: (simulationID: Int, walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int)?
    var body: some View {
        GeometryReader { geometry in
            let maxEmission = transportTypes.map { $0.emission }.max() ?? 1.0
             let totalHeight = geometry.size.height - 140 
            VStack(alignment: .center) {
                Text("Carbon Emissions: Simulation \(simulationIDText)")
                    .font(.headline)
                    .bold()
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: geometry.size.width)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                HStack(alignment: .bottom, spacing: 10) {

                        ForEach(transportTypes, id: \.name) { transportType in
                            let emission = calculateEmission(for: transportType.name)

                            let height = (totalHeight * CGFloat(emission / maxEmission))
                            Rectangle()
                                .frame(width: geometry.size.width * 0.17, height: height > 0 ? height : 1)
                                .cornerRadius(8)
                    }
                }
                .frame(maxWidth: geometry.size.width, alignment: .center)
                
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(transportTypes, id: \.name) { transportType in
                        Text(transportType.name)
                            .font(.headline)
                            .alignmentGuide(.bottom) { d in d[.bottom] }
                            .frame(width: geometry.size.width * 0.17)
                    }
                }
                .frame(width: geometry.size.width)
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(transportTypes, id: \.name) { transportType in
                        Text(String(format: "%.1f", transportType.emission))
                            .font(.caption)
                            .alignmentGuide(.bottom) { d in d[.bottom] }
                            .frame(width: geometry.size.width * 0.17)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                Spacer()
                Text("Total CO2 in Grams per Passenger Kilometer for Every Passenger in Each Transport Type")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: geometry.size.width, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
    }
    private var simulationIDText: String {
        if let simulationID = simulationData?.simulationID {
            return "\(simulationID + 1)"
        } else {
            return "Unknown"
        }
    }
    private func calculateEmission(for transportType: String) -> Double {
        guard let data = simulationData else { return 0.0 }
        switch transportType {
        case "Walk":
            return Double(data.walkCount) * walk.emission
        case "Bike":
            return Double(data.bikeCount) * bike.emission
        case "Car":
            return Double(data.carCount) * car.emission
        case "Jeep":
            return Double(data.jeepCount) * jeep.emission
        case "Bus":
            return Double(data.busCount) * bus.emission
        default:
            return 0.0
        }
    }
}

struct RoadspaceChartView: View {
    var transportTypes: [TransportRoadspace]
    var simulationData: (simulationID: Int, walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int)?
    var body: some View {
        GeometryReader { geometry in
            let maxRoadspace = transportTypes.map { $0.roadspace }.max() ?? 1.0
            let totalHeightR = geometry.size.height - 140 
            VStack(alignment: .center) {
                Text("Roadspace: Simulation \(simulationIDText)")
                    .font(.headline)
                    .bold()
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: geometry.size.width)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                HStack(alignment: .bottom, spacing: 10) {

                    ForEach(transportTypes, id: \.name) { transportType in
                        let roadspace = calculateRoadspace(for: transportType.name)

                        let heightR = (totalHeightR * CGFloat(roadspace / maxRoadspace))
                        Rectangle()
                            .frame(width: geometry.size.width * 0.17, height: heightR > 0 ? heightR : 1)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: geometry.size.width, alignment: .center)

                
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(transportTypes, id: \.name) { transportType in
                        Text(transportType.name)
                            .font(.headline)
                            .alignmentGuide(.bottom) { d in d[.bottom] }
                            .frame(width: geometry.size.width * 0.17)
                    }
                }
                .frame(width: geometry.size.width)
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(transportTypes, id: \.name) { transportType in
                        Text(String(format: "%.1f", transportType.roadspace))
                            .font(.caption)
                            .alignmentGuide(.bottom) { d in d[.bottom] }
                            .frame(width: geometry.size.width * 0.17)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                Spacer()
                Text("Total Road Space in Square Meters taken by All Vehicles or Individuals")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: geometry.size.width, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                
                
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
    }
    private var simulationIDText: String {
        if let simulationID = simulationData?.simulationID {
            return "\(simulationID + 1)"
        } else {
            return "Unknown"
        }
    }
    private func calculateRoadspace(for transportType: String) -> Double {
        guard let data = simulationData else { return 0.0 }
        switch transportType {
        case "Walk":
            return Double(data.walkCount) * walk.length * walk.width 
        case "Bike":
            return Double(data.bikeCount) * bike.length * bike.width
        case "Car":
            return Double(data.carCount) * car.length * car.width
        case "Jeep":
            let adjustedJeepCount = Int(ceil(Double(data.jeepCount) / Double(18)))
            return Double(adjustedJeepCount) * jeep.length * jeep.width
        case "Bus":
            let adjustedBusCount = Int(ceil(Double(data.busCount) / Double(50)))
            return Double(adjustedBusCount) * bus.length * bus.width
        default:
            return 0.0
        }
    }

}

struct AvgTimeView: View {
    var simulationData: (simulationID: Int, walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int)?
    var body: some View {
        GeometryReader { geometry in
            
            VStack(alignment: .center) {
                Text("Time: Simulation \(simulationIDText)")
                    .font(.headline)
                    .bold()
                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: geometry.size.width)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], alignment: .center, spacing: 20) {
                    VStack {
                        Image(systemName: "figure.walk")
                            .font(.title3)
                        Text("\(String(format: "%.1f", walk.speed)) km/h")
                         .font(.title2)
                              .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                    }
                    .frame(maxWidth: geometry.size.width)

                    VStack {
                        Image(systemName: "bicycle")
                            .font(.title3)
                        Text("\(String(format: "%.1f", bike.speed)) km/h")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: geometry.size.width)
                    VStack {
                        Image(systemName: "car")
                            .font(.title3)
                        Text("\(String(format: "%.1f", car.speed)) km/h")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: geometry.size.width)
                    VStack {
                        Image(systemName: "truck.box.fill")
                            .font(.title3)
                        Text("\(String(format: "%.1f", jeep.speed)) km/h")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: geometry.size.width)
                    VStack {
                        Image(systemName: "bus")
                            .font(.title3)
                        Text("\(String(format: "%.1f", bus.speed)) km/h")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: geometry.size.width)
                   
                    
                    
                }
                 .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: geometry.size.width, alignment: .center)
                .padding(.vertical)
                VStack {
                    let avgtime = calculateAvgTime()

                     Text("Average Time")
                     Text("\(timeStringFrom(hours: avgtime))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }

                .frame(maxWidth: geometry.size.width, alignment: .center)
                Spacer()
                Text("Average Speed to Travel 1 Kilometer for all Transportation Modes")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)

                    .alignmentGuide(.bottom) { d in d[.bottom] }
                    .frame(width: geometry.size.width, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            .frame(width: geometry.size.width, height: geometry.size.height)
            
        }
    }
    private var simulationIDText: String {
        if let simulationID = simulationData?.simulationID {
            return "\(simulationID + 1)"
        } else {
            return "Unknown"
        }
    }
    private func calculateAvgTime() -> Double {
        guard let data = simulationData else { return 0.0 }
        
        let distance = 1.0
        let adjustedJeepCount = Int(ceil(Double(data.jeepCount) / Double(18)))
        let adjustedBusCount = Int(ceil(Double(data.busCount) / Double(50)))
        
        let walkTime = distance / walk.speed
        let bikeTime = distance / bike.speed
        let carTime = distance / car.speed
        let jeepTime = distance / jeep.speed
        let busTime = distance / bus.speed
 
        let totalWalkTime = Double(data.walkCount) * walkTime
        let totalBikeTime = Double(data.bikeCount) * bikeTime
        let totalCarTime = Double(data.carCount) * carTime
        let totalJeepTime = Double(adjustedJeepCount) * jeepTime
        let totalBusTime = Double(adjustedBusCount) * busTime
        
        let totalTime = totalWalkTime + totalBikeTime + totalCarTime + totalJeepTime + totalBusTime

        let totalCount = Double(data.walkCount + data.bikeCount + data.carCount + adjustedBusCount + adjustedJeepCount)
        
        if totalCount == 0 {
            return 0.0
        }
        let averageTime: Double = totalTime / totalCount
        
        return averageTime
    }
    private func timeStringFrom(hours: Double) -> String {
        let totalSeconds = Int(hours * 3600)
        let hoursComponent = totalSeconds / 3600
        let minutesComponent = (totalSeconds % 3600) / 60
        let secondsComponent = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hoursComponent, minutesComponent, secondsComponent)
    }

}

struct LogoView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Text("G17 University Consortium Project")
                    .fontWeight(.bold)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: 0x050505))
                      
                Image("Greenovation")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: geometry.size.height * 0.7)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .frame(maxHeight: .infinity, alignment: .center)       
        }
    }    
}

struct SDG9View: View {    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                Image("SDG9")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
        }
    }    
}

struct SDG11View: View {    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                Image("SDG11")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
        }
    }    
}

struct SDG13View: View {
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                Image("SDG13")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
        }
    }    
}

struct DataView: View {
    var simulationData: [(simulationID: Int, walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int)]
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var commuterAllocator = CommuterAllocator()
    let stripeHeight = 16.0
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
                    Text("Number of Commuters per Transport Type")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(hex: 0x050505))
                    LazyVGrid(columns: halfAdaptiveColumn , spacing: 10) { 
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "figure.walk")
                                    .font(.subheadline)
                                Text("Walk")
                                    .font(.subheadline)
                                Spacer()
                            }

                            Spacer()
                            HStack {
                                Text("\(simulationData.last?.walkCount ?? 0)")
                                    .font(.system(size: 48))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(height: 120, alignment: .leading)
                        .frame(maxWidth: geometry.size.width)
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
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: "bicycle")
                                    .font(.subheadline)
                                Text("Bike")
                                    .font(.subheadline)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Text("\(simulationData.last?.bikeCount ?? 0)")
                                    .font(.system(size: 48))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                        }
                        .padding()
                        .frame(height: 120)
                        .frame(maxWidth: geometry.size.width)
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

                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: "car")
                                    .font(.subheadline)
                                Text("Car")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            Spacer()
                            HStack {
                                Text("\(simulationData.last?.carCount ?? 0)")
                                    .font(.system(size: 48))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                        }
                        .padding()
                        .frame(height: 120)
                        .frame(maxWidth: geometry.size.width)
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
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: "truck.box.fill")
                                    .font(.subheadline)
                                Text("Jeep")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            Spacer()
                            HStack {
                                Text("\(simulationData.last?.jeepCount ?? 0)")
                                    .font(.system(size: 48))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                        }
                        .padding()
                        .frame(height: 120)
                        .frame(maxWidth: geometry.size.width)
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
                        
                        VStack(alignment: .trailing) {
                            HStack {
                                Image(systemName: "bus")
                                    .font(.subheadline)
                                Text("Bus")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            Spacer()
                            HStack {
                                Text("\(simulationData.last?.busCount ?? 0)")
                                    .font(.system(size: 48))
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                        }
                        .padding()
                        .frame(height: 120)
                        .frame(maxWidth: geometry.size.width)
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
                        .frame(height: 120)
                        .frame(maxWidth: geometry.size.width)
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
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))] , spacing: 10)  {
                        Button(action: {
                            if let url = URL(string: "https://hal.science/hal-03543183/document#:~:text=2.6%2F%20Food%20to%20Foot%20carbon%20emissions%20per%20unit%20length&text=h%2Fkm%20for%20Walking%20and,range%20from%206%20to%2050\n") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Source 1")
                                .frame(width: 100,height: 48)

                                .background(Color(hex: 0x308966))
                                .cornerRadius(24)
                        }
                        Button(action: {
                            if let url = URL(string: "https://www.adb.org/sites/default/files/linked-documents/52220-001-cca.pdf\n") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Source 2")
                                .frame(width: 100,height: 48)
                                .background(Color(hex: 0x308966))
                                .cornerRadius(24)
                        }
                        Button(action: {
                            if let url = URL(string: "https://unbox.ph/news/mmda-edsa-average-speed-better-than-pre-pandemic-times/") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Source 3")
                                .frame(width: 100,height: 48)
                                .background(Color(hex: 0x308966))
                                .cornerRadius(24)
                        }
                        Button(action: {
                            if let url = URL(string: "https://openjicareport.jica.go.jp/pdf/11580552_02.pdf") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Source 4")
                                .frame(width: 100,height: 48)
                                .background(Color(hex: 0x308966))
                                .cornerRadius(24)
                        }
                        Button(action: {
                            if let url = URL(string: "http://epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Source 5")
                                .frame(width: 100,height: 48)
                                .background(Color(hex: 0x308966))
                                .cornerRadius(24)
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
