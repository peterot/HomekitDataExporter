import SwiftUI
import HomeKit

struct RoomView: View {
    
    var homeId: UUID
    
    @ObservedObject var model: HomeViewModel

    var body: some View {
        List {
            Section(header: HStack {
                Text("Rooms")
            }) {
                ForEach(model.rooms.sorted(by:  { $0.name < $1.name }), id: \.uniqueIdentifier) { room in
                    NavigationLink {
                        AccessoriesView(homeId: homeId, roomId: room.uniqueIdentifier, model: model)
                    } label: {
                        Text("\(room.name)")
                    }
                }
            }
        }.onAppear(){
            model.findRooms(homeId: homeId)
        }
    }
}
