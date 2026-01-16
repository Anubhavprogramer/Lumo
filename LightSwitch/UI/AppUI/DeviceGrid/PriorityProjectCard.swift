//
//  PriorityProjectCard.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import Foundation
import SwiftUI

struct PriorityProjectCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Priority Project")
                .font(.caption)
                .foregroundColor(Color("textColor"))
            
            Text(project.name)
                .font(.title2)
                .fontWeight(.bold)
            
            ProgressView(value: project.progress)
                .progressViewStyle(.linear)
                .tint(Color("SwitchColor"))
            
            Text("\(Int(project.progress * 100))% completed")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("cardColor"))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
