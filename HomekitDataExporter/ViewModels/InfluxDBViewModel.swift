import SwiftUI

class InfluxDBViewModel: NSObject, ObservableObject {
    private let bucketKey = "influxdb_bucket"
    private let orgKey = "influxdb_org"
    private let tokenKey = "influxdb_token"
    private let urlKey = "influxdb_url"
    
    @Published var influxDBBucket: String = ""
    @Published var influxDBOrg: String = ""
    @Published var influxDBToken: String = ""
    @Published var influxDBUrl: String = ""
    
    @Published var lastConnectionResult: String = ""
    
    var settingsComplete: Bool {
        return !influxDBBucket.isEmpty
            && !influxDBOrg.isEmpty
            && !influxDBToken.isEmpty
            && !influxDBUrl.isEmpty
    }
    
    
    private var timer: Timer!
    private var influxDBService = InfluxDBService()
    private var homeService = HomeService()
    
    
    override init(){
        super.init()
        loadFromUserDefaults()
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 60.0 * 5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
    }

    func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let storedBucket = defaults.string(forKey: bucketKey) {
            influxDBBucket = storedBucket
        }
        if let storedOrg = defaults.string(forKey: orgKey) {
            influxDBOrg = storedOrg
        }
        if let storedToken = defaults.string(forKey: tokenKey) {
            influxDBToken = storedToken
        }
        if let storedUrl = defaults.string(forKey: urlKey) {
            influxDBUrl = storedUrl
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(influxDBBucket, forKey: bucketKey)
        defaults.set(influxDBOrg, forKey: orgKey)
        defaults.set(influxDBToken, forKey: tokenKey)
        defaults.set(influxDBUrl, forKey: urlKey)
    }
    
    func testConnection() {
        fireTimer()
    }
    
    
    @objc func fireTimer() {
        if settingsComplete {
            Task {
                let accessoryData = homeService.collectAccessoryData()
                
                let result: String
                do {
                    try await influxDBService.write(bucket: influxDBBucket, org: influxDBOrg, token: influxDBToken, url: influxDBUrl, data:accessoryData)
                    result = "Successfully connected - " + Date().description
                } catch {
                    result  = "Error writing to InfluxDB:\n\n\(error)"
                }
                await MainActor.run {
                    lastConnectionResult = result
                }
            }
        }
    }
}
