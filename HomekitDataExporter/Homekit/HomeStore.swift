import Foundation
import HomeKit
import Combine

class HomeService: NSObject, ObservableObject, HMHomeManagerDelegate {
    
    
    @Published var homes: [HMHome] = []
    @Published var rooms: [HMRoom] = []
    @Published var accessories: [HMAccessory] = []
    @Published var accessoryData: [AccessoryData] = []
    
    private var manager: HMHomeManager!

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
    
    func collectAccessoryData() {
        var accessoryData : [AccessoryData] = []
        
        homes.forEach { home in
            home.accessories.forEach{ accessory in
                accessoryData.append(contentsOf: getAccessoryData(home: home, accessory: accessory))
            }
        }
        print(accessoryData)
    }
    
    func getAccessoryData(home: HMHome, accessory: HMAccessory) -> [AccessoryData] {
        
        var tags: [String: String] = [:]
        tags["Home"] = home.name
        tags["Room"] = accessory.room?.name ?? "Unknown"
        tags["Accessory"] = accessory.name
        tags["AccessoryType"] = accessory.category.localizedDescription
        
        if let accessoryInfo = accessory.services.first(where: {$0.serviceType == HMServiceTypeAccessoryInformation}) {
            accessoryInfo.characteristics.forEach{ charactersistic in
                if let valueStr = charactersistic.value as? String {
                    tags[charactersistic.localizedDescription] = valueStr
                }
            }
        }
        
        print(tags)
        var accessoryData : [AccessoryData] = []
        accessory.services.forEach{ service in
            print("S:" + service.localizedDescription)
            if service.serviceType != HMServiceTypeAccessoryInformation {
                service.characteristics.forEach{ characteristic in
                    if let numericValue = parseCharacteristicValueAsDouble(characteristic: characteristic) {
                        if let metadata = characteristic.metadata?.manufacturerDescription {
                            accessoryData.append(AccessoryData(measurement: metadata, value: numericValue, tags: tags))
                        } else {
                            let measurement = characteristic.localizedDescription
                            accessoryData.append(AccessoryData(measurement: measurement, value: numericValue, tags: tags))
                        }
                    }
                }
            }
        }
        
        return accessoryData
    }
    
    func parseCharacteristicValueAsDouble(characteristic : HMCharacteristic) -> Double? {
        var value: Double?
        switch characteristic.value {
            case let someInt as Int:
                value = Double(someInt)
            case let someDouble as Double:
                value = someDouble
            case let someFloat as Float:
                value = Double(someFloat)
            case let someBool as Bool:
                value = someBool ? 1 : 0
            case let someNumber as NSNumber:
                value = someNumber.doubleValue
            default:
                value = nil
            }
        return value
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
        accessoryData = getAccessoryData(home: home, accessory: accessory)
    }
    
}
