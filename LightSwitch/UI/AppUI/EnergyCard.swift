//
//  EnergyCard.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI

struct EnergyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estimated energy expenses this month")
                .font(.caption)
            
            HStack {
                ProgressView(value: 0.6)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(Color("ProgressBarColor"))
                    
                
                Text("89 €")
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color("cardColor"))
        .cornerRadius(20)
    }
}
