//
//  IdeaSection.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import Foundation
import SwiftUI

struct IdeaSection: View {
    let ideas: [Idea]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ideas")
                .font(.headline)
                .foregroundColor(Color("textColor"))
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(ideas) { idea in
                    IdeaCard(idea: idea)
                }
            }
        }
    }
}
