//
//  WelcomeHeader.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI


struct WelcomeHeader: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome Home")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("Garret Reynolds")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Image(systemName: "house.fill")
                .font(.largeTitle)
        }
    }
}
