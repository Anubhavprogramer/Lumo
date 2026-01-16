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
                    .foregroundColor(Color("textColor"))
            }
            .toggleStyle(SwitchToggleStyle())
            .tint(Color("SwitchColor"))
        }
        .padding()
        .background(Color("cardColor"))
        .cornerRadius(20)
    }
}

struct IdeaCard: View {
    let idea: Idea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(idea.title)
                .fontWeight(.semibold)
                .foregroundColor(Color("textColor"))
            
            Text(idea.tag)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("cardColor"))
        .cornerRadius(16)
    }
}
