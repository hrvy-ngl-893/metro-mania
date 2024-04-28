import SwiftUI

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    
    static var samplePages: [Page] = [
        Page(name: "Welcome to Metro Mania!", description: "Understand the climate effects of different transport modes in traffic.", imageUrl: "MetroManiaLogo", tag: 0),
        
        Page(name: "The Worst Traffic in the World", description: "Metro Manila is infamous for its traffic moving at a snail's pace.", imageUrl: "Traffic1", tag: 1),
        
        Page(name: "Explore and Understand Why", description: "This App advances climate awareness using technology.", imageUrl: "Explore1", tag: 2),
        
        Page (name: "Other Impacts", description: "Innovation and sustainable communities are also this App's concern.", imageUrl: "Impact1", tag: 3),
        
        Page (name: "About this Simulation", description: "You will allocate 100 commuters to transport options to travel 1 km.", imageUrl: "Simu1", tag: 4)
    ]
}
