import SwiftUI
import SpriteKit
import GameplayKit
class GameScene: SKScene {
    private var spawner = Spawner()
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Road5")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        background.name = "background"
        addChild(background)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for child in children where child is SKSpriteNode {
            if (child as! SKSpriteNode).position.y > 1300 {
                child.removeFromParent()
            }
        }
    }
}
public var simulationData: [(simulationID: Int, walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int)] = []
public var logData: [(logID: Int, logTitle: String, emissions: Double, roadspace: Double, avgtime: Double)] = []


class Spawner {
    private var spriteCount = 0
    private var adjustedMinY: CGFloat = 0
    private var scene: SKScene?
    public static var simulationIDCount: Int = 0


    init() {}
    func runSimulation(walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int, in scene: SKScene) {
        self.scene = scene
        clearSprites()
        
        let adjustedJeepCount = Int(ceil(Double(jeepCount) / Double(18)))
        let adjustedBusCount = Int(ceil(Double(busCount) / Double(50)))
        let adjustment = -CGFloat(adjustedBusCount * 1000)
        - CGFloat(carCount * 140)
        - CGFloat(bikeCount * 20)
        - CGFloat(adjustedJeepCount * 200)
        - CGFloat(walkCount * 8)
        
        adjustedMinY += adjustment
        spawnSprites(type: "Bus", count: adjustedBusCount)
        spawnSprites(type: "Jeep", count: adjustedJeepCount)
        spawnSprites(type: "Walk", count: walkCount)
        spawnSprites(type: "Bike", count: bikeCount)
        spawnSprites(type: "Car", count: carCount)
        
        
        simulationData.append((Spawner.simulationIDCount, walkCount, bikeCount, carCount, jeepCount, busCount))
        let emissionTotal: Double = (Double(walkCount) * walk.emission) + (Double(bikeCount) * bike.emission) + (Double(carCount) * car.emission) + (Double(jeepCount) * jeep.emission) + (Double(busCount) * bus.emission)
        print("\(emissionTotal)")
        let roadspaceTotal: Double = (Double(walkCount) * (walk.width * walk.length)) + (Double(bikeCount) * (bike.width * bike.length)) + (Double(carCount) * (car.width * car.length)) + (Double(adjustedJeepCount) * (jeep.width * jeep.length)) + (Double(adjustedBusCount) * (bus.width * bus.length))
        
        print("\(roadspaceTotal)")
        let averageTime = calculateAvgTime(walkCount: walkCount, bikeCount: bikeCount, carCount: carCount, jeepCount: adjustedJeepCount, busCount: adjustedBusCount)
        print("\(averageTime)")
        logData.append((logID: Spawner.simulationIDCount, logTitle: "Simulation \(Spawner.simulationIDCount+1)", emissions: emissionTotal, roadspace: roadspaceTotal, avgtime: averageTime))
        print("\(logData)")
        moveSpritesNorth()
        Spawner.simulationIDCount += 1
        adjustedMinY = 0
        print("\(simulationData)")
    }
    
    private func spawnSprites(type: String, count: Int) {
        guard let scene = scene else { return }
        let imageName: String
        switch type {
        case "Walk":
            imageName = "Walk1"
        case "Bike":
            imageName = "Bike1"
        case "Car":
            imageName = "Car1"
        case "Jeep":
            imageName = "Jeep1"
        case "Bus":
            imageName = "Bus1"
        default:
            return
        }
        
        let minX: CGFloat = 250
        let maxX: CGFloat = 550
        let maxY: CGFloat = 10
        
        for _ in 0..<count {
            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.name = imageName.lowercased()
            
            let isPlaced = placeSpriteWithoutOverlap(sprite, scene: scene, minX: minX, maxX: maxX, maxY: maxY)
            
            if isPlaced {
                scene.addChild(sprite)
                spriteCount += 1
            }
        }
    }
    private func calculateAvgTime(walkCount: Int, bikeCount: Int, carCount: Int, jeepCount: Int, busCount: Int) -> Double {
        
        let distance = 1.0
        // Calculate time for each mode of transport
        let walkTime = distance / walk.speed
        let bikeTime = distance / bike.speed
        let carTime = distance / car.speed
        let jeepTime = distance / jeep.speed
        let busTime = distance / bus.speed


        // Calculate total time for all commuters
        let totalWalkTime = Double(walkCount) * walkTime
        let totalBikeTime = Double(bikeCount) * bikeTime
        let totalCarTime = Double(carCount) * carTime
        let totalJeepTime = Double(jeepCount) * jeepTime
        let totalBusTime = Double(busCount) * busTime
        
        let totalTime = totalWalkTime + totalBikeTime + totalCarTime + totalJeepTime + totalBusTime

        let totalCount = Double(walkCount + bikeCount + carCount + busCount + jeepCount)

        if totalCount == 0 {
            return 0.0 // Or handle it appropriately based on your logic
        }
        let averageTime: Double = totalTime / totalCount  // Assuming 100 commuters
        
        return averageTime
    }
    private func clearSprites() {
        guard let scene = scene else { return }
        for child in scene.children where child is SKSpriteNode && child.name != "background" {
            child.removeFromParent()
        }
    }
    
    private func placeSpriteWithoutOverlap(_ sprite: SKSpriteNode, scene: SKScene, minX: CGFloat, maxX: CGFloat, maxY: CGFloat) -> Bool {
        var attempts = 0
        let maxAttempts = 500
        var isPlaced = false
        
        while attempts < maxAttempts && !isPlaced {
            let xPosition = CGFloat(arc4random_uniform(UInt32(maxX - minX))) + minX
            let yPosition = CGFloat(arc4random_uniform(UInt32(maxY - adjustedMinY))) + adjustedMinY
            sprite.position = CGPoint(x: xPosition, y: yPosition)
            isPlaced = !checkForOverlap(sprite, scene: scene)
            attempts += 1
        }
        
        return isPlaced
    }
    
    private func checkForOverlap(_ sprite: SKSpriteNode, scene: SKScene) -> Bool {
        return scene.children.contains { child -> Bool in
            guard let child = child as? SKSpriteNode, child.zPosition != -1 else { return false }
            return child.frame.intersects(sprite.frame)
        }
    }
    
    private func moveSpritesNorth() {
        guard let scene = scene else { return }
        let moveNorthAction = SKAction.moveBy(x: 0, y: 500, duration: 0.3)
        moveNorthAction.timingMode = .linear
        for child in scene.children where child is SKSpriteNode && (child as! SKSpriteNode).zPosition != -1 {
            (child as! SKSpriteNode).run(SKAction.repeatForever(moveNorthAction))
        }
    }
}

struct SpriteKitView: UIViewRepresentable {
    typealias UIViewType = SKView
    var scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.presentScene(scene)
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}
