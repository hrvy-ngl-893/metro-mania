import SwiftUI
let stripeHeight = 16.0
struct SourceButton: View {
    var label: String
    var url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: self.url) {
                UIApplication.shared.open(url)
            }
        }) {
            Text(label)
                .frame(width: 100, height: 48)
                .background(Color(hex: 0x308966))
                .cornerRadius(24)
        }
    }
}

struct CommuterInfoView: View {
    var commuterType: String
    var count: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: getImageName(for: commuterType))
                    .font(.subheadline)
                Text(commuterType)
                    .font(.subheadline)
                Spacer()
            }
            Spacer()
            HStack {
                Text("\(count)")
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
    }
    
    private func getImageName(for commuterType: String) -> String {
        switch commuterType {
            case "Walk": return "figure.walk"
            case "Bike": return "bicycle"
            case "Car": return "car"
            case "Jeep": return "truck.box.fill"
            case "Bus": return "bus"
            default: return ""
        }
    }
}

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
                        let height = emission > 0 ? (totalHeight * CGFloat(emission / maxEmission)) : 0
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
                        let heightR = roadspace > 0 ? (totalHeightR * CGFloat(roadspace / maxRoadspace)) : 0
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
