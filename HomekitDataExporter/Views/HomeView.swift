import HomeKit
import SwiftUI

struct HomeView: View {
    @ObservedObject var model: HomeViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack {
                    Text("Homes")
                }) {
                    ForEach(model.homes.sorted(by:  { $0.name < $1.name }), id: \.uniqueIdentifier) { home in
                        NavigationLink {
                            RoomView(homeId: home.uniqueIdentifier, model: model)
                        } label: {
                            Text("\(home.name)")
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
