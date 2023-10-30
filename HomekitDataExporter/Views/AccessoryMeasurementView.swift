import SwiftUI
import HomeKit

struct AccessoryMeasurementView: View {
    
    var homeId: UUID
    var accessoryId: UUID
    @ObservedObject var model: HomeViewModel

    var body: some View {
        List {
            Section(header: HStack {
                Text("Measurements")
            }) {
                ForEach(model.accessoryData.sorted(by:  { $0.measurement < $1.measurement }), id: \.measurement) { accessoryData in
                    NavigationLink(value: accessoryData){
                        Text("\(accessoryData.measurement)")
                    }.navigationDestination(for: AccessoryData.self) {
                        AccessoryDataView(accessoryData: $0)
                    }
                }
            }
        }.onAppear(){
            model.findAccessoryData(homeId: homeId, accessoryId: accessoryId)
        }
    }
}
