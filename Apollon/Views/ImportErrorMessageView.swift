import SwiftUI

struct ImportErrorMessageView: View {
    @Binding var errorMessage: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Import failed")
                    .foregroundColor(.red)
                    .bold()
                Spacer()
                Button {
                    errorMessage = ""
                } label: {
                    Image(systemName: "x.circle")
                        .foregroundColor(.red)
                }
            }
            Text(errorMessage)
                .foregroundColor(.red)
        }
        .padding(5)
        .overlay {
            RoundedRectangle(cornerRadius: 3)
                .stroke(.red, lineWidth: 1)
        }
        .background {
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color.red.opacity(0.1))
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}
