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
        VStack(spacing: 20) {
            TopTabBar()
                        
            WelcomeHeader()
            
            EnergyCard()
            
            DeviceGrid()
            
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        AppUI(isOn: true)
    }
}

