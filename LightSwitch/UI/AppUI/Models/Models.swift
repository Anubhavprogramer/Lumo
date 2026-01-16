//
//  Models.swift
//  LightSwitch
//
//  Created by Anubhav Dubey on 16/01/26.
//

import Foundation

struct Idea: Identifiable {
    let id = UUID()
    let title: String
    let tag: String
}

struct Project: Identifiable {
    let id = UUID()
    let name: String
    let progress: Double
}
