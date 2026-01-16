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
    
    private let maxPull: CGFloat = 140
    private let triggerDIstance: CGFloat = 90
    
    var body: some View {
        ZStack {
            //MARK: Background
            Color(isOn ? .black : .white)
                .ignoresSafeArea()
            
            VStack{
                Spacer(minLength: 40)
                
                //Pull thread
                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 4, height: 120 + pullOffset)
                    
                    //Weight /knob
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 14, height: 14)
                        .offset(y: pullOffset)
                }
                .gesture(pullGesture)
                .animation(.interactiveSpring(response: 0.35,
                                              dampingFraction: 0.65,
                                              blendDuration: 0.2),
                            value: pullOffset)
                
                Spacer()
            }
            VStack{
                Spacer()
                Text(isOn ? "Mode: Dark" : "Mode: Light")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isOn ? .white : .black)
                Spacer(minLength: 80)
            }
        }
        .onChange(of: isOn) {
            applyInterfaceStyle($0)
        }
    }
    private var pullGesture: some Gesture {
        DragGesture()
            .onChanged {value in
                let rawPull = max(0, value.translation.height)
                
                let resistedPull = pow(rawPull, 0.85)
                
                pullOffset = min(resistedPull, maxPull)
            }
            .onEnded { _ in
                if pullOffset > triggerDIstance {
                    toggleMode()
                }
                
                pullOffset = 0
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

#Preview {
    ContentView()
}
