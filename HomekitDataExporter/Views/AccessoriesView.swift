import SwiftUI
import HomeKit

struct AccessoriesView: View {
    
    var homeId: UUID
    var roomId: UUID
    @ObservedObject var model: HomeViewModel

    var body: some View {
        List {
            Section(header: HStack {
                Text("Accessories")
            }) {
                ForEach(model.accessories.sorted(by:  { $0.name < $1.name }), id: \.uniqueIdentifier) { accessory in
                    NavigationLink(value: accessory){
                        Text("\(accessory.name)")
                    }
                    .navigationDestination(for: HMAccessory.self) {
                        AccessoryMeasurementView(homeId: homeId, accessoryId: $0.uniqueIdentifier, model: model)
                    }
                }
            }
        }.onAppear(){
            model.findAccessories(homeId: homeId, roomId: roomId)
        }
    }
}
