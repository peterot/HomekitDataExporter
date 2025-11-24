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
                    NavigationLink {
                        AccessoryMeasurementView(homeId: homeId, accessoryId: accessory.uniqueIdentifier, model: model)
                    } label: {
                        Text("\(accessory.name)")
                    }
                }
            }
        }.onAppear(){
            model.findAccessories(homeId: homeId, roomId: roomId)
        }
    }
}
