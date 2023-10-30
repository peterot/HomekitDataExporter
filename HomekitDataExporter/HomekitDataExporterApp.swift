import SwiftUI

@main
struct HomekitDataExporterApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(model: HomeViewModel())
        }
    }
}
