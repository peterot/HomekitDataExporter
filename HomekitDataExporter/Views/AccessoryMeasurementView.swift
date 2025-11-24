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
                    NavigationLink {
                        AccessoryDataView(accessoryData: accessoryData)
                    } label: {
                        Text("\(accessoryData.measurement)")
                    }
                }
            }
        }.onAppear(){
            model.findAccessoryData(homeId: homeId, accessoryId: accessoryId)
        }
    }
}
