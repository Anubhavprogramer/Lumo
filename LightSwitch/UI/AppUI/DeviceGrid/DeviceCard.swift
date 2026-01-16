//
//  DeviceCard.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI

struct DeviceCard: View {
    let title: String
    let icon: String
    @State private var isOn = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title)
            
            Text(title)
                .fontWeight(.semibold)
            
            Toggle(isOn: $isOn) {
                Text(isOn ? "On" : "Off")
            }
            .toggleStyle(SwitchToggleStyle())
        }
        .padding()
        .background(Color("CardColor"))
        .cornerRadius(20)
    }
}
