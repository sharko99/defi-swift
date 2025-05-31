import SwiftUI

struct ContentView: View {

    var body: some View {
        DynamicHeaderView().preferredColorScheme(.dark)
    }
}

struct DynamicHeaderView: View {
    let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 10 / 255, green: 4 / 255, blue: 20 / 255),
                        Color(red: 10 / 255, green: 5 / 255, blue: 13 / 255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                Circle()
                    .fill(Color.red.opacity(0.4))
                    .frame(width: 200, height: 200)
                    .blur(radius: 100)
                    .offset(x: -100, y: -200)
                    .opacity(0.2)

                Circle()
                    .fill(Color.pink.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .blur(radius: 100)
                    .offset(x: 150, y: -100)
                    .opacity(0.2)

                Circle()
                    .fill(Color.purple.opacity(0.4))
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(x: 100, y: 300)
                    .opacity(0.2)
            }
            ScrollView {
                VStack(spacing: 0) {
                    GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            scrollOffset = -geo.frame(in: .named("scroll")).origin.y
                        }
                        return Color.clear
                    }
                    .frame(height: 0)

                    Spacer().frame(height: 280)

                    VStack(spacing: 16) {
                        ForEach(1..<31) { i in
                            HStack {
                                Spacer()
                                    .padding(.top, 90)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .opacity(0.5)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .coordinateSpace(name: "scroll")
            .mask(
                VStack(spacing: 0) {
                        Spacer().frame(height: 60 + topInset)
                        Color.white
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
            )

            animatedHeader
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .shadow(radius: 8)

            VStack {
                Spacer()
                CustomTabBar()
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemGroupedBackground))
    }

    private var animatedHeader: some View {
        let minHeight: CGFloat = 60
        let maxHeight: CGFloat = 180
        let clampedOffset = min(max(scrollOffset, 0), maxHeight - minHeight)
        let height = maxHeight - clampedOffset

        let progress = Double(clampedOffset / (maxHeight - minHeight))

        let fadeOut = max(0, 1 - abs(progress - 0))
        let fadeIn  = max(0, (progress - 0.5) * 2)

        return VStack {
            Spacer()
            ZStack {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 6) {
                        Text("Patrimoine brut")
                            .bold()
                            .foregroundColor(.white.opacity(0.9))
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white.opacity(0.7))
                            .offset(y: 1)
                    }

                    Text("226 €")
                        .font(.system(size: 42, weight: .regular))
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text("1 jour")
                                .font(.caption)
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 8, height: 8)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                        )
                        .clipShape(Capsule())
                        
                        Text("0 €")
                            .font(.caption)
                            .foregroundColor(.white)

                        HStack(spacing: 2) {
                            Text("0,00 %")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .opacity(fadeOut)

                VStack(spacing: 0) {
                    HStack {
                        Text("226 €")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()

                        HStack(spacing: 12) {
                            Text("0 €")
                                .font(.caption)
                                .foregroundColor(.white)

                            HStack(spacing: 2) {
                                Text("0,00 %")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal)

                    
                }
                .opacity(fadeIn)
            }
            
            
            Spacer()
        }
        .padding(.top, topInset)
        .frame(height: height + topInset)
        .animation(.easeInOut(duration: 0.2), value: scrollOffset)
        .overlay(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white.opacity(0), location: 0.0),
                    .init(color: Color.white.opacity(fadeIn * 0.15), location: 0.3),
                    .init(color: Color.white.opacity(fadeIn * 0.15), location: 0.7),
                    .init(color: Color.white.opacity(0), location: 1.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1),
            alignment: .bottom
        )
        
    }
}

struct CustomTabBar: View {
    @State private var selectedTab = 0

    let icons = ["square.grid.2x2.fill", "chart.bar.xaxis", "append.page", "safari", "building.columns.fill"]
    let titles = ["Synthèse", "Patrimoine", "Budget", "Analyse", "Investir"]

    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: icons[index])
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(selectedTab == index ? Color(hex: "f4be7e") : Color.gray)
                    Text(titles[index])
                        .font(.caption)
                        .foregroundColor(selectedTab == index ? Color(hex: "f4be7e") : Color.gray)
                }
                .onTapGesture {
                    selectedTab = index
                }
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 25)
        .padding(.bottom, 30)
        .background(
            ZStack(alignment: .top) {
                Color(hex: "151316")
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.white.opacity(0), location: 0.0),
                        .init(color: Color.white.opacity(0.12), location: 0.05),
                        .init(color: Color.white.opacity(0.12), location: 0.95),
                        .init(color: Color.white.opacity(0), location: 1.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 1)
            }
        )
    }
}

#Preview {
    ContentView()
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
