import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var diagrams: [ApollonDiagram]
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Diagrams
                    Section(header: Text("Diagrams")) {
                        HStack {
                            Text("Remove all diagrams")

                            Spacer()

                            Button {
                                for diagram in diagrams {
                                    modelContext.delete(diagram)
                                }
                            } label: {
                                Text("Remove")
                                    .padding(5)
                                    .foregroundColor(.red)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 3)
                                            .stroke(.red, lineWidth: 1)
                                    )
                            }
                        }
                    }

                    // Appearance
                    Section(header: Text("Appearance")) {
                        Toggle("Dark mode", isOn: $isDarkMode)
                            .tint(.accentColor)
                    }

                    // Information
                    Section(header: Text("Information")) {
                        Link("Apollon", destination: URL(string: "https://apollon.ase.in.tum.de")!)
                            .foregroundColor(.accentColor)
                        Link("GitHub", destination: URL(string: "https://github.com/ls1intum/Apollon")!)
                            .foregroundColor(.accentColor)
                        Link("Documentation", destination: URL(string: "https://apollon-library.readthedocs.io/en/latest/index.html")!)
                            .foregroundColor(.accentColor)
                    }

                    // Version
                    HStack {
                        Spacer()
                        Text("Version 1.0")
                            .foregroundColor(ApollonColor.toolBarItemColor)
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("tum_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                }
                ToolbarItem(placement: .principal) {
                    Text("Apollon")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ApollonColor.toolBarBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
