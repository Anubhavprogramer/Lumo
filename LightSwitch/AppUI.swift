//
//  AppUI.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI

struct AppUI: View {

    // MARK: - Input State
    let isOn: Bool

    var body: some View {
        VStack {
            Spacer()

            Text(isOn ? "Mode: Dark" : "Mode: Light")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isOn ? .white : .black)
                .animation(.easeInOut(duration: 0.2), value: isOn)

            Spacer(minLength: 80)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AppUI(isOn: true)
    }
}

