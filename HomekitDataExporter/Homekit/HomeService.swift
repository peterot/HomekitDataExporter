import Foundation
import HomeKit
import Combine

class HomeService: NSObject, ObservableObject {
    
    @Published var homes: [HMHome] = []
    
    private var manager: HMHomeManager!

    override init(){
        super.init()
        load()
    }
    
    func load() {
        if manager == nil {
            manager = .init()
        }
    }
    
    func collectAccessoryData() -> [AccessoryData] {
        var accessoryData : [AccessoryData] = []
        
        self.manager.homes.forEach { home in
            home.accessories.forEach{ accessory in
                accessoryData.append(contentsOf: getAccessoryData(home: home, accessory: accessory))
            }
        }
        return accessoryData
    }
    
    func getAccessoryData(home: HMHome, accessory: HMAccessory) -> [AccessoryData] {
        
        var tags: [String: String] = [:]
        tags["Home"] = home.name
        tags["Room"] = accessory.room?.name ?? "Unknown"
        tags["Accessory"] = accessory.name
        tags["AccessoryId"] = accessory.uniqueIdentifier.uuidString
        tags["AccessoryType"] = accessory.category.localizedDescription
        
        if let accessoryInfo = accessory.services.first(where: {$0.serviceType == HMServiceTypeAccessoryInformation}) {
            accessoryInfo.characteristics.forEach{ charactersistic in
                if let valueStr = charactersistic.value as? String {
                    tags[charactersistic.localizedDescription] = valueStr
                }
            }
        }
        
        var accessoryData : [AccessoryData] = []
        let isReachableNum = accessory.isReachable ? 1.0 : 0
        accessoryData.append(AccessoryData(measurement: "Reachable", value: isReachableNum, tags: tags))
        
        accessory.services.forEach{ service in
            var extendedTags = tags;
            extendedTags["ServiceType"] = service.localizedDescription;
            if service.serviceType != HMServiceTypeAccessoryInformation {
                service.characteristics.forEach{ characteristic in
                    if let numericValue = parseCharacteristicValueAsDouble(characteristic: characteristic) {
                        if let metadata = characteristic.metadata?.manufacturerDescription {
                            accessoryData.append(AccessoryData(measurement: metadata, value: numericValue, tags: extendedTags))
                        } else {
                            let measurement = characteristic.localizedDescription
                            accessoryData.append(AccessoryData(measurement: measurement, value: numericValue, tags: extendedTags))
                        }
                    }
                }
            }
        }
        
        return accessoryData
    }
    
    func parseCharacteristicValueAsDouble(characteristic : HMCharacteristic) -> Double? {
        
        Task{
            try await characteristic.readValue()
        }
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
    
}
