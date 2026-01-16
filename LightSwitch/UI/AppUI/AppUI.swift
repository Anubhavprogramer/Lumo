//
//  AppUI.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import SwiftUI

struct AppUI: View {

    let ideas = [
        Idea(title: "Smart Home Automation", tag: "IoT"),
        Idea(title: "AI Note Summarizer", tag: "AI"),
        Idea(title: "Focus Tracker App", tag: "Productivity")
    ]
    
    let projects = [
        Project(name: "LightSwitch App", progress: 0.7),
//        Project(name: "IdeaVault", progress: 0.4)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                WelcomeHeader()
                
                PriorityProjectCard(project: projects[0])
                
                ProgressGraphCard()
                
                IdeaSection(ideas: ideas)
                
                ProjectSection(projects: projects)
            }
            .padding()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    AppUI()
}

