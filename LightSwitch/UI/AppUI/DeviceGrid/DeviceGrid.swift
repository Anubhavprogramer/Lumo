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

struct ProjectSection: View {
    let projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Projects")
                .font(.headline)
                .foregroundColor(Color("textColor"))
            
            ForEach(projects) { project in
                ProjectCard(project: project)
            }
        }
    }
}

struct ProjectCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(project.name)
                .fontWeight(.semibold)
                .foregroundColor(Color("textColor"))
            
            ProgressView(value: project.progress)
                .progressViewStyle(.linear)
                .tint(Color("SwitchColor"))
        }
        .padding()
        .background(Color("cardColor"))
        .cornerRadius(16)
    }
}
