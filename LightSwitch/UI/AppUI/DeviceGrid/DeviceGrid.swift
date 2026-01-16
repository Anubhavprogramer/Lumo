//
//  DeviceCardSecondary.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI

struct DeviceGrid: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            DeviceCard(title: "Smart Spotlights", icon: "lightbulb.fill")
            DeviceCard(title: "Air Samsung F7", icon: "snowflake")
            DeviceCard(title: "Smart TV", icon: "tv.fill")
        }
    }
}
