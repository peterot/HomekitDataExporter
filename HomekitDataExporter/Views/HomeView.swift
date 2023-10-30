import HomeKit
import SwiftUI

struct HomeView: View {
    
    @State private var path = NavigationPath()
    @ObservedObject var model: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: HStack {
                    Text("Homes")
                }) {
                    ForEach(model.homes.sorted(by:  { $0.name < $1.name }), id: \.uniqueIdentifier) { home in
                        NavigationLink(value: home){
                            Text("\(home.name)")
                        }.navigationDestination(for: HMHome.self){
                            RoomView(homeId: $0.uniqueIdentifier, model: model)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(model: HomeViewModel())
}
