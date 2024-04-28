import SwiftUI
import SpriteKit

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
} 

 
struct StyledButton: ViewModifier {
    func body(content: Content) -> some View {
        
        GeometryReader {geometry in
            content
                .frame(width: 100,height: 48)
                .foregroundColor(Color(hex: 0xf5f5f5))
                .background(Color(hex: 0xff9e3d))
                .cornerRadius(24)
        }
        
    }
}

extension View {
    func styledButton() -> some View {
        self.modifier(StyledButton())
    }
}

struct ContentView: View {
    @State private var welcome_view_shown = false
    var body: some View {
        if welcome_view_shown {
            CombinedView()
        } else {
            WelcomeView(welcomeViewShown: $welcome_view_shown)

        }
    }
}

struct CombinedView: View {
    @ObservedObject var commuterAllocator = CommuterAllocator()
    @State private var showAlert = false
    @State private var alertMessage = "All 100 commuters must be allocated"
    
    var spawner = Spawner()
    var gameScene: GameScene = {
        let scene = GameScene()
        scene.size = CGSize(width: 800, height: 1200)
        scene.scaleMode = .aspectFill
        return scene
    }()
    @State private var showData: Bool = false
    @State private var showLog: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let isWideScreen = geometry.size.width > geometry.size.height
            VStack {
                VStack(alignment: .center) {
                    Text("Metro Mania")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color(hex: 0xF5F5F5))
                        .padding(10)
                        .background(Color(hex: 0x050505))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.yellow, lineWidth: 6)
                        )
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 6)
                        )
                    
                }
                .background(Color(hex: 0xf5f5f5))
                .frame(width: geometry.size.width, height: 100, alignment: .center)
                .background(Image("MiniHeader"))
                
                if isWideScreen {
                    HStack(alignment: .bottom) {
                        VStack {
                            Spacer()
                            VStack {
                                Text("Allocate 100 Commuters")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: 0x050505))
                                    .bold()
                                    .padding(.vertical, 20)
                                    .multilineTextAlignment(.center)
                                
                                ForEach(["Walk", "Bike", "Car", "Jeep", "Bus"], id: \.self) { transportType in
                                    HStack {
                                        Text("\(transportType): \(commuterAllocator.getCommuterCount(for: transportType))")
                                            .font(.title3)
                                            .foregroundColor(Color(hex: 0x050505))
                                            .frame(width: 100, alignment: .leading)
                                        
                                        Slider(value: Binding(
                                            get: {
                                                Double(commuterAllocator.getCommuterCount(for: transportType))
                                            },
                                            set: { newValue in
                                                commuterAllocator.setCommuterCount(for: transportType, to: Int(newValue))
                                            }
                                        ), in: 0.0...100.0, step: 1.0)
                                    }
                                    .padding(.horizontal)
                                }
                                Spacer()
                                GeometryReader{geometry in
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            if commuterAllocator.totalCount != 100 {
                                                showAlert = true
                                                alertMessage = "Total number of passengers must be exactly 100."
                                            } else {
                                                spawner.runSimulation(walkCount: commuterAllocator.walkCount, bikeCount: commuterAllocator.bikeCount, carCount: commuterAllocator.carCount, jeepCount: commuterAllocator.jeepCount, busCount: commuterAllocator.busCount, in: gameScene)
                                            }
                                        }, label: {
                                            Text("Run")
                                                .frame(width: geometry.size.width * 0.3,height: 48)
                                                .foregroundColor(Color(hex: 0xf5f5f5))
                                                .background(Color(hex: 0x308966))
                                                .cornerRadius(24)
                                        })
                                        .alert(isPresented: $showAlert) {
                                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                        }
                                        
                                        
                                        
                                        Spacer()
                                        Button(action: {
                                            showData.toggle()
                                        }, label: {
                                            Text("Data")
                                                .frame(width: geometry.size.width * 0.3,height: 48)
                                                .foregroundColor(Color(hex: 0xf5f5f5))
                                                .background(Color(hex: 0x308966))
                                                .cornerRadius(24)
                                        })
                                        .sheet(isPresented: $showData) {
                                            DataView(simulationData: simulationData)
                                        }
                                        Spacer()
                                        Button(action: {
                                            showLog.toggle()
                                        }, label: {
                                            Text("Logs")
                                                .frame(width: geometry.size.width * 0.3,height: 48)
                                                .foregroundColor(Color(hex: 0xf5f5f5))
                                                .background(Color(hex: 0x308966))
                                                .cornerRadius(24)
                                        })
                                        .sheet(isPresented: $showLog) {
                                            LogView()

                                        }
                                        Spacer()
                                        
                                    }
                                    
                                    .padding(.top, 20)
                                }
                                
                                Spacer()
                                VStack {
                                    Text("Animation does not represent real world phyiscs.")
                                    Text("Car, jeep, and bus speeds based on Manila's speed limits.")
                                    Text("Data based on traffic operating in ideal conditions.")
                                    Text("Walking and cycling speed based on averages.")
                                }
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 4)
                                .foregroundColor(Color(hex: 0x050505))
                                Spacer()
                            }
                            
                            .frame(alignment: .center)
                            .padding()
                            .background(Color(hex: 0xF5f5f5))
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.7)
                            
                            .cornerRadius(48)
                            Spacer()
                        }
                        .frame(minWidth: geometry.size.width * 0.5)

                        .background(Color(hex: 0x40BF4F))
                        
                        
                        SpriteView(scene: gameScene)
                            .frame(width: geometry.size.width * 0.5)
                            .ignoresSafeArea()
                    }
                    .frame(height: geometry.size.height - 100)
                    .background(Color(hex: 0x40BF4F))
                    .padding(.top, -8)
                    
                } else {
                    VStack {
                        SpriteView(scene: gameScene)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.5 )
                            .padding(.top, -7)
                        
                        VStack {
                            ScrollView {
                                VStack {
                                    Text("Allocate 100 Commuters")
                                        .font(.system(size: 24))
                                        .bold()
                                        .padding(.vertical, 20)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(hex: 0x050505))
                                    
                                    ForEach(["Walk", "Bike", "Car", "Jeep", "Bus"], id: \.self) { transportType in
                                        HStack {
                                            Text("\(transportType): \(commuterAllocator.getCommuterCount(for: transportType))")
                                                .font(.title3)
                                                .foregroundColor(Color(hex: 0x050505))
                                                .frame(width: 100, alignment: .leading)
                                            
                                            Slider(value: Binding(
                                                get: {
                                                    Double(commuterAllocator.getCommuterCount(for: transportType))
                                                },
                                                set: { newValue in
                                                    commuterAllocator.setCommuterCount(for: transportType, to: Int(newValue))
                                                }
                                            ), in: 0.0...100.0, step: 1.0)
                                            .accentColor(Color(hex: 0x308966))
                                            .padding(4)
                                            .background(
                                                RoundedRectangle(cornerRadius: 24)
                                                    .fill(Color.gray.opacity(0.2))
                                            )
                                        }
                                        .padding(.horizontal)
                                    }
                                    
                                    GeometryReader{geometry in
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                if commuterAllocator.totalCount != 100 {
                                                    showAlert = true
                                                    alertMessage = "Total number of passengers must be exactly 100."
                                                } else {
                                                    spawner.runSimulation(walkCount: commuterAllocator.walkCount, bikeCount: commuterAllocator.bikeCount, carCount: commuterAllocator.carCount, jeepCount: commuterAllocator.jeepCount, busCount: commuterAllocator.busCount, in: gameScene)

                                                }
                                            }, label: {
                                                Text("Run")
                                                    .frame(width: geometry.size.width * 0.3,height: 48)
                                                    .background(Color(hex: 0x308966))
                                                    .cornerRadius(24)
                                            })
                                            .alert(isPresented: $showAlert) {
                                                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                            }
                                            
                                            
                                            
                                            
                                            Spacer()
                                            Button(action: {
                                                showData.toggle()
                                            }, label: {
                                                Text("Data")
                                                    .frame(width: geometry.size.width * 0.3,height: 48)
                                                    .background(Color(hex: 0x308966))
                                                    .cornerRadius(24)
                                            })
                                            .sheet(isPresented: $showData) {
                                                DataView(simulationData: simulationData)
                                            }
                                            Spacer()
                                            Button(action: {
                                                showLog.toggle()
                                            }, label: {
                                                Text("Logs")
                                                    .frame(width: geometry.size.width * 0.3,height: 48)
                                                    .background(Color(hex: 0x308966))
                                                    .cornerRadius(24)
                                            })
                                            .sheet(isPresented: $showLog) {
                                                LogView()
                                            }
                                            Spacer()
                                        }
                                        .foregroundColor(Color(hex: 0xf5f5f5))
                                        .padding(.top, 20)
                                    }

                                    VStack {
                                        Text("Animation does not represent real world phyiscs.")
                                        Text("Car, jeep, and bus speeds based on Manila's speed limits.")
                                        Text("Data based on traffic operating in ideal conditions.")
                                        Text("Walking and cycling speed based on averages.")
                                    }
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(hex: 0x050505))
                                    .padding(.top, -250)

                                }
                                .frame(height: 800)
                            }
                            .padding(32)
                            .background(Color(hex: 0xf5f5f5))
                            .frame(maxWidth: .infinity)
                            .cornerRadius(48)
                        }
                        .frame(height: geometry.size.height * 0.5)
                        .padding(.top, -60)
                    }
                }
            }
            .background(Color(hex: 0xf5f5f5))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
