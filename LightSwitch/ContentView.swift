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

    // rope/knob pose
    @State private var pullX: CGFloat = 0
    @State private var knobBounce: CGFloat = 0

    // simple physics state (position & velocity)
    @State private var vx: CGFloat = 0
    @State private var vy: CGFloat = 0
    @State private var lastTick: Date = .now
    @State private var isDragging: Bool = false

    private let maxPull: CGFloat = 160
    private let triggerDIstance: CGFloat = 95
    private let maxSide: CGFloat = 32

    // "thread" tuning
    private let ropeTopLength: CGFloat = 210
    private let ropeWidth: CGFloat = 70
    private let knobSize: CGFloat = 44

    var body: some View {
        ZStack {
            Color(Color("BackgroundColor")).ignoresSafeArea()

            AppUI()

            HStack {
                Spacer()

                VStack {
                    VStack(spacing: 0) {
                        // Rope + knob must share the same coordinate space, so the rope end can
                        // visually stick to the knob center.
                        ThreadRope(
                            height: ropeTopLength + pullOffset + knobBounce,
                            swayX: pullX,
                            isOn: isOn,
                            slack: max(0, -pullOffset),
                            knobSize: knobSize
                        )

                        KnobView(isOn: isOn)
                            .frame(width: knobSize, height: knobSize)
                            .offset(x: pullX, y: pullOffset + knobBounce)
                            .shadow(color: .black.opacity(isOn ? 0.35 : 0.15), radius: 10, x: 0, y: 6)
                    }
                    // Wider hit area & drawing area so rope doesn't clip/disappear when swaying.
                    .frame(width: ropeWidth, alignment: .trailing)
                    .padding(.trailing, 40)
                    .ignoresSafeArea(edges: .top)
                    .contentShape(Rectangle())
                    .gesture(pullGesture)

                    Spacer()
                }
            }

            // Physics tick: when not dragging, continue to settle like a rope.
            TimelineView(.animation) { timeline in
                Color.clear
                    .onChange(of: timeline.date) { _, newValue in
                        tickPhysics(now: newValue)
                    }
            }
            .allowsHitTesting(false)
        }
        .onChange(of: isOn) {
            applyInterfaceStyle($0)
        }
    }

    private var pullGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                isDragging = true

                // allow both down & a bit up (slack)
                let rawY = value.translation.height
                let down = max(0, rawY)
                let up = min(0, rawY) * 0.35

                let resistedPull = pow(down, 0.85)
                pullOffset = min(resistedPull, maxPull) + up

                // looser sideways when slack, tighter when pulled
                let rawX = value.translation.width
                let tension = 1 + (max(0, pullOffset) / 60)
                let resistedX = rawX / tension
                pullX = max(-maxSide, min(maxSide, resistedX))

                // reset velocities while user is holding
                vx = 0
                vy = 0
                knobBounce = 0
            }
            .onEnded { _ in
                isDragging = false

                if pullOffset > triggerDIstance {
                    toggleMode()
                }

                // give an initial "release" impulse proportional to displacement
                vx = -pullX * 4.5
                vy = -pullOffset * 2.2

                // quick snap to remove hard stop feel; the rest is physics
                withAnimation(.interpolatingSpring(stiffness: 240, damping: 16)) {
                    knobBounce = 18
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    withAnimation(.interpolatingSpring(stiffness: 260, damping: 16)) {
                        knobBounce = 0
                    }
                }
            }
    }

    // MARK: - Physics (simple rope-like spring)
    private func tickPhysics(now: Date) {
        guard !isDragging else {
            lastTick = now
            return
        }

        let dt = min(1.0 / 30.0, max(0.0, now.timeIntervalSince(lastTick)))
        lastTick = now

        // Spring back to rest: pullOffset -> 0, pullX -> 0
        // Tweak these to taste.
        let k: CGFloat = 34      // spring stiffness
        let c: CGFloat = 8.5     // damping
        let g: CGFloat = 58      // pseudo gravity pulling down when above rest (for "free fall" feel)

        // X dynamics
        let ax = (-k * pullX) - (c * vx)
        vx += ax * dt
        pullX += vx * dt

        // Y dynamics
        // When pulled up (negative pullOffset), gravity helps pull it down.
        let gravity = pullOffset < 0 ? g : 0
        let ay = (-k * pullOffset) - (c * vy) + gravity
        vy += ay * dt
        pullOffset += vy * dt

        // clamp tiny jitter
        if abs(pullX) < 0.05 && abs(vx) < 0.05 { pullX = 0; vx = 0 }
        if abs(pullOffset) < 0.05 && abs(vy) < 0.05 { pullOffset = 0; vy = 0 }

        // hard limits (so it doesn't explode)
        pullX = max(-maxSide, min(maxSide, pullX))
        pullOffset = max(-40, min(maxPull, pullOffset))
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
    let slack: CGFloat
    let knobSize: CGFloat

    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height

            // Anchor at top.
            let start = CGPoint(x: w / 2, y: 0)

            // End should visually meet the knob center.
            // Because the knob is placed immediately after the rope view, the knob's center Y
            // is just below the rope's bottom edge. We pull the rope slightly beyond its height
            // so it "touches" the knob.
            let end = CGPoint(x: w / 2 + swayX * 0.65, y: h + knobSize * 0.22)

            // Add slack by introducing a small fold (extra curvature) near the top.
            let fold = min(32, slack * 1.0)
            let c1 = CGPoint(x: w / 2 + swayX * 1.2, y: h * 0.30)
            let c2 = CGPoint(x: w / 2 - swayX * 0.35, y: h * 0.74)

            var path = Path()
            path.move(to: start)
            path.addCurve(
                to: end,
                control1: CGPoint(x: c1.x, y: c1.y + fold),
                control2: CGPoint(x: c2.x, y: c2.y + fold * 0.45)
            )

            context.stroke(
                path,
                with: .color(Color("SwitchColor").opacity(isOn ? 0.92 : 0.86)),
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
        // Wider frame so the curve never clips off-screen when swaying.
        .frame(width: 70, height: max(80, height))
        .clipped(antialiased: false)
        .accessibilityHidden(true)
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
