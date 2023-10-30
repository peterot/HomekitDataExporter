import Foundation
import HomeKit
import Combine

class HomeViewModel: NSObject, ObservableObject, HMHomeManagerDelegate {
    
    
    @Published var homes: [HMHome] = []
    @Published var rooms: [HMRoom] = []
    @Published var accessories: [HMAccessory] = []
    @Published var accessoryData: [AccessoryData] = []
    
    private var manager: HMHomeManager!
    private var service: HomeService = HomeService()

    override init(){
        super.init()
        load()
    }
    
    func load() {
        if manager == nil {
            manager = .init()
            manager.delegate = self
        }
    }
    

    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("DEBUG: Updated Homes!")
        self.homes = self.manager.homes
    }
 
    func findAccessories(homeId: UUID) {
        guard let devices = homes.first(where: {$0.uniqueIdentifier == homeId})?.accessories else {
            print("ERROR: No Accessory not found!")
            return
        }
        accessories = devices
    }
    
    func findRooms(homeId: UUID) {
        guard let homeRooms = homes.first(where: {$0.uniqueIdentifier == homeId})?.rooms else {
            print("ERROR: No Room not found!")
            return
        }
        rooms = homeRooms
    }
    
    func findAccessories(homeId: UUID, roomId: UUID) {
        guard let devices = homes.first(where: {$0.uniqueIdentifier == homeId})?.rooms.first(where: {$0.uniqueIdentifier == roomId})?.accessories else {
            print("ERROR: No Accessory not found!")
            return
        }
        accessories = devices
    }
    
    func findAccessoryData(homeId: UUID, accessoryId: UUID) {
        guard let home = homes.first(where: {$0.uniqueIdentifier == homeId}) else {
            print("ERROR: No Accessory not found!")
            return
        }
        guard let accessory = homes.first(where: {$0.uniqueIdentifier == homeId})?.accessories.first(where: {$0.uniqueIdentifier == accessoryId}) else {
            print("ERROR: No Accessory not found!")
            return
        }
        accessoryData = service.getAccessoryData(home: home, accessory: accessory)
    }
    
}
