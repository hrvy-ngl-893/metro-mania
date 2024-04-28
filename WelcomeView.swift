import SwiftUI

struct WelcomeView: View {
    @State private var pageIndex =  0
    @Binding var welcomeViewShown: Bool
    private let pages: [Page] = Page.samplePages
    var body: some View {
        ZStack {
            TabView(selection: $pageIndex) {
                ForEach(pages) { page in
                    VStack {
                        Spacer()
                        WelcomePage(page: page)
                        Spacer()
                    }
                    .tag(page.tag)
                }
            }
            .animation(.easeInOut, value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            if pageIndex >  0 {
                Button(action: {
                    pageIndex -=  1
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            Button(action: {
                if pageIndex < pages.count -  1 {
                    pageIndex +=  1
                } else {
                    goToZero()
                    welcomeViewShown.toggle()
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .background(Color(hex: 0xF5f5f5))
    }
    func goToZero() {
        pageIndex =  0
    }
}
struct WelcomePage: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(page.imageUrl)
                .resizable()
                .scaledToFit()
                .cornerRadius(30)
                .padding()
            
            Text(page.name)
                .font(.system(size: 32))
                .bold()
                .foregroundColor(Color(hex: 0xF5F5F5))
                .padding(10)
                .background(Color(hex: 0x020202))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.yellow, lineWidth: 6)
                )
                .padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 6)
                )
                .multilineTextAlignment(.center)
                .padding(.bottom, 12)
            
            Text(page.description)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .font(.system(size: 24))
                .padding(.bottom, 200)
                .foregroundColor(Color(hex: 0x020202))
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}
