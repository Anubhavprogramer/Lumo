//
//  TopTabBar.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI


struct TopTabBar: View {
    var body: some View {
        HStack(spacing: 20) {
            Text("Living Room")
                .fontWeight(.bold)
                .underline()
            
            Text("Kitchen")
                .foregroundColor(.gray)
            
            Text("Dining")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
