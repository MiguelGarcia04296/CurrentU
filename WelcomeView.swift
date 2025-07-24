import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Optional: Soft gradient background for cuteness
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.cyan.opacity(0.2), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                HStack(alignment: .center, spacing: 16) {
                    Image("octee")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 4)
                    Text("CurrentU")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color.blue)
                        .shadow(color: Color.cyan.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                    .scaleEffect(2)
                    .padding(.top, 12)
                Text("Welcome!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .opacity(0.7)
            }
        }
    }
}

#Preview {
    WelcomeView()
} 
