import SwiftUI

@main
struct TapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @AppStorage("taps") private var taps: Int = 0
    @AppStorage("bestLevel") private var bestLevel: Int = 0
    @State private var scale: CGFloat = 1.0
    @State private var flash = false

    var level: Int { taps / 10 }

    // Бесконечные цвета: hue = уровень * 37 (взаимно просто с 360 — не зациклится быстро)
    var hue: Double { Double((level * 37) % 360) }
    var nextHue: Double { Double(((level + 1) * 37) % 360) }

    var bg: Color { Color(hue: hue / 360, saturation: 0.55, brightness: 0.28) }
    var bgTop: Color { Color(hue: hue / 360, saturation: 0.75, brightness: 0.45) }
    var accent: Color { Color(hue: nextHue / 360, saturation: 0.8, brightness: 0.9) }

    var body: some View {
        ZStack {
            LinearGradient(colors: [bgTop, bg], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.6), value: level)

            VStack(spacing: 28) {
                Text("УРОВЕНЬ \(level)")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 6)

                Text("рекорд: \(bestLevel)")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                ProgressView(value: Double(taps % 10), total: 10)
                    .tint(.white)
                    .frame(width: 220)

                Button {
                    taps += 1
                    if level > bestLevel { bestLevel = level }
                    flash = true
                    scale = 0.85
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.4)) {
                        scale = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        flash = false
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 220, height: 220)
                            .shadow(color: .black.opacity(0.3), radius: 20)
                        Circle()
                            .stroke(accent, lineWidth: 6)
                            .frame(width: 220, height: 220)
                        Text("\(taps)")
                            .font(.system(size: 72, weight: .black, design: .rounded))
                            .foregroundStyle(.black)
                    }
                    .scaleEffect(scale)
                    .brightness(flash ? 0.35 : 0)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 80)
        }
    }
}
