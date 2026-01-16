//
//  ProgressGraphCard.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import Foundation
import SwiftUI


struct ProgressGraphCard: View {
    
    let data: [Double] = [0.3, 0.5, 0.8, 0.6, 0.9]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(data.indices, id: \.self) { index in
                    Capsule()
                        .fill(Color("SwitchColor"))
                        .frame(width: 20, height: data[index] * 120)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("cardColor"))
        .cornerRadius(20)
    }
}
