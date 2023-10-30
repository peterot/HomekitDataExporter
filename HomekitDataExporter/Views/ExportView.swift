import SwiftUI

struct ExportView: View {
    enum FocusedField:Hashable{
            case bucket_input, org_input, token_input, url_input
        }
    @FocusState var focus:FocusedField?
    
    @ObservedObject var settings = InfluxDBViewModel()
    
    var body: some View {
        VStack {
            Text("InfluxDB Export Settings")
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text("Bucket").font(.title3)
                
                TextField(
                    "MyBucket",
                    text: $settings.influxDBBucket
                )
                .focused($focus, equals: .bucket_input)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }.padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("Organisation").font(.title3)
                
                TextField(
                    "MyOrg",
                    text: $settings.influxDBOrg
                )
                .focused($focus, equals: .org_input)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }.padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("Token").font(.title3)
                
                TextField(
                    "[TOKEN]",
                    text: $settings.influxDBToken
                )
                .focused($focus, equals: .token_input)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }.padding(.top, 20)
            
            VStack(alignment: .leading) {
                Text("URL").font(.title3)
                
                TextField(
                    "InfluxDB connection URL",
                    text: $settings.influxDBUrl
                )
                .focused($focus, equals: .url_input)
                .keyboardType(.URL)
                .textContentType(.URL)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            }
            .padding(.top, 20)
            
            if settings.settingsComplete {
                Button {
                    settings.testConnection()
                } label: {
                    Text("Test connection")
                        .padding(20)
                }
                
                Text(settings.lastConnectionResult)
                    .lineLimit(10)
            }
            
        }
        .padding()
        .onChange(of: focus) {
            settings.save()
        }
    }
    
    
}

#Preview {
    ExportView()
}
