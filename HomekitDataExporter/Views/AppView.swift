import HomeKit
import SwiftUI

struct AppView: View {
    
    @ObservedObject var model: HomeViewModel
    
    var body: some View {
        TabView {
            ExportView()
                .badge("!")
                .tabItem {
                    Label("InfluxDB Export Settings", systemImage: "gearshape")
                }
            HomeView(model: model)
                .tabItem {
                    Label("Home Explorer", systemImage: "house")
                }
        }
    }
}

#Preview {
    AppView(model: HomeViewModel())
}
