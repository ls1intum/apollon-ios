import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DiagramListView()
                .tabItem {
                    Label("Diagrams", systemImage: "square.on.square")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
