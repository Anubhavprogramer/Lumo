//
//  ContentView.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI

struct ContentView: View {

    //MARK: STATE
    @State private var pullOffset: CGFloat = 0
    @State private var isOn: Bool = false
    @State private var pullX: CGFloat = 0
    @State private var knobBounce: CGFloat = 0

    // extra rope dynamics
    @State private var releaseVelocityX: CGFloat = 0

    private let maxPull: CGFloat = 140
    private let triggerDIstance: CGFloat = 90
    private let maxSide: CGFloat = 26

    var body: some View {
        ZStack {
            //MARK: Background
            Color(Color("BackgroundColor"))
                .ignoresSafeArea()

            AppUI()

            HStack {
                Spacer()

                VStack {

                    // Pull thread
                    VStack(spacing: 0) {
                        ThreadRope(
                            height: 420 + pullOffset + knobBounce,
                            swayX: pullX,
                            isOn: isOn
                        )

                        // Weight / knob
                        KnobView(isOn: isOn)
                            .offset(x: pullX, y: pullOffset + knobBounce)
                            .shadow(color: .black.opacity(isOn ? 0.35 : 0.15), radius: 10, x: 0, y: 6)
                    }
                    .padding(.trailing, 40)
                    .ignoresSafeArea(edges: .top)
                    .contentShape(Rectangle())
                    .gesture(pullGesture)

                    Spacer()
                }
            }

        }
        .onChange(of: isOn) {
            applyInterfaceStyle($0)
        }
    }

    private var pullGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                // Vertical pull (with resistance) — allow tiny upward push too
                // so it feels like a flexible thread rather than a strict "only down" slider.
                let rawY = value.translation.height
                let down = max(0, rawY)
                let up = min(0, rawY) * 0.25 // small upward give

                let resistedPull = pow(down, 0.85)
                pullOffset = min(resistedPull, maxPull) + up

                // Horizontal sway (more flexible + keeps working even when not pulled much)
                let rawX = value.translation.width
                let tension = 1 + (max(0, pullOffset) / 70) // more tension when pulled => less side movement
                let resistedX = rawX / tension

                // approximate release velocity (for nicer fling)
                releaseVelocityX = resistedX - pullX

                pullX = max(-maxSide, min(maxSide, resistedX))

                // When dragging, don't keep residual bounce
                knobBounce = 0
            }
            .onEnded { _ in
                if pullOffset > triggerDIstance {
                    toggleMode()
                }

                // Bigger, more "thread-like" bounce: decaying oscillation
                // Vertical snap
                withAnimation(.interpolatingSpring(stiffness: 260, damping: 14)) {
                    pullOffset = 0
                    knobBounce = 26
                }

                // Horizontal snap with a bit of fling (based on last velocity)
                let fling = max(-12, min(12, releaseVelocityX * 5))
                withAnimation(.interpolatingSpring(stiffness: 220, damping: 14)) {
                    pullX = fling
                }

                // 2nd oscillation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    withAnimation(.interpolatingSpring(stiffness: 240, damping: 15)) {
                        knobBounce = -14
                        pullX = -fling * 0.55
                    }
                }

                // 3rd oscillation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                    withAnimation(.interpolatingSpring(stiffness: 260, damping: 16)) {
                        knobBounce = 8
                        pullX = fling * 0.28
                    }
                }

                // settle
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                    withAnimation(.interactiveSpring(response: 0.45, dampingFraction: 0.78, blendDuration: 0.12)) {
                        knobBounce = 0
                        pullX = 0
                    }
                }
            }
    }

    // MARK: - Toggle
    private func toggleMode() {
        isOn.toggle()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    private func applyInterfaceStyle(_ enabled: Bool) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }

        window.overrideUserInterfaceStyle = enabled ? .dark : .light
    }
}

// MARK: - Rope + Knob components

private struct ThreadRope: View {
    let height: CGFloat
    let swayX: CGFloat
    let isOn: Bool

    var body: some View {
        // NOTE:
        // SwiftUI doesn't render SVG directly.
        // Convert `thread.svg` -> a single-page vector PDF and add it to Assets as `RopeThread`
        // with "Render As: Template Image" to allow tinting via SwitchColor.

        if UIImage(named: "RopeThread") != nil {
            Image("RopeThread")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color("SwitchColor"))
                // stretch vertically to match pull height
                .scaledToFill()
                .frame(width: 26, height: max(40, height))
                .clipped()
                .offset(x: swayX * 0.55)
                .accessibilityHidden(true)
        } else {
            // Fallback: keep the programmatic rope so the project still runs
            Canvas { context, size in
                let w = size.width
                let h = size.height

                let start = CGPoint(x: w / 2, y: 0)
                let end = CGPoint(x: w / 2 + swayX * 0.65, y: h)
                let control = CGPoint(x: w / 2 + swayX, y: h * 0.55)

                var path = Path()
                path.move(to: start)
                path.addQuadCurve(to: end, control: control)

                context.stroke(
                    path,
                    with: .color(Color("SwitchColor").opacity(isOn ? 0.9 : 0.85)),
                    style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round)
                )

                var highlight = path
                highlight = highlight.applying(CGAffineTransform(translationX: 0.9, y: 0))
                context.stroke(
                    highlight,
                    with: .color(.white.opacity(isOn ? 0.22 : 0.16)),
                    style: StrokeStyle(lineWidth: 1.0, lineCap: .round)
                )
            }
            .frame(width: 18, height: max(40, height))
        }
    }
}

private struct KnobView: View {
    let isOn: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color("SwitchColor").opacity(0.95),
                            Color("SwitchColor").opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(.white.opacity(isOn ? 0.25 : 0.18), lineWidth: 1)
                .padding(2)

            Image(systemName: "power")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(isOn ? 0.9 : 0.7))
        }
        .frame(width: 44, height: 44)
        .accessibilityLabel("Pull switch")
    }
}

#Preview {
    ContentView()
}
