import SwiftUI
import HomeKit

struct AccessoryDataView: View {
    
    var accessoryData: AccessoryData

    var body: some View {
        List {
            Section(header: HStack {
                Text(accessoryData.measurement + ": " + String(format: "%.2f", accessoryData.value))
                    .font(.system(size: 20, weight: .heavy, design: .default))
            }) {
                ForEach(accessoryData.tags.sorted(by: >), id: \.key) { key, value in
                    Text(key + ": " + value)
                }
            }
        }
    }
}
