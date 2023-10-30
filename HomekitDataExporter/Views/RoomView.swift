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
                    NavigationLink(value: room){
                        Text("\(room.name)")
                    }.navigationDestination(for: HMRoom.self) {
                        AccessoriesView(homeId: homeId, roomId: $0.uniqueIdentifier, model: model)
                    }
                }
            }
        }.onAppear(){
            model.findRooms(homeId: homeId)
        }
    }
}
