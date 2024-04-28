import SwiftUI

class CommuterAllocator: ObservableObject {
    private let walkCapacity = 1
    private let bikeCapacity = 1
    private let carCapacity = 1
    private let jeepCapacity = 18
    private let busCapacity = 50
    
    @Published var walkCount = 0
    @Published var bikeCount = 0
    @Published var carCount = 0
    @Published var jeepCount = 0
    @Published var busCount = 0
    @Published var totalCount = 0
    
  
    func getCommuterCount(for transportType: String) -> Int {
        switch transportType {
        case "Walk": return walkCount
        case "Bike": return bikeCount
        case "Car": return carCount
        case "Jeep": return jeepCount
        case "Bus": return busCount
        default: return 0
        }
    }
    
    func setCommuterCount(for transportType: String, to value: Int) {
        switch transportType {
        case "Walk": walkCount = value
        case "Bike": bikeCount = value
        case "Car": carCount = value
        case "Jeep": jeepCount = value
        case "Bus": busCount = value
        default: break
        }
        
        totalCount = walkCount + bikeCount + carCount + jeepCount + busCount
        
        if totalCount > 100 {
            switch transportType {
            case "Walk":
                walkCount -= totalCount - 100
            case "Bike":
                bikeCount -= totalCount - 100
            case "Car":
                carCount -= totalCount - 100
            case "Jeep":
                jeepCount -= totalCount - 100
            case "Bus":
                busCount -= totalCount - 100
            default:
                break
            }
        }
    }
}
