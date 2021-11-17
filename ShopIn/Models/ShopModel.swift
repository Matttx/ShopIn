//
//  ShopModel.swift
//  ShopIn
//
//  Created by Matteo on 14/11/2021.
//

import Foundation

struct ShopModel: Equatable, Codable {
    var id = UUID()
    var content: String
    var quantity: Int = 1
    var label: String = ""
    var priority: Priority = .none
    var reminder: Date? = nil
    var store: String = ""
    var amount: Double = 0.00
    var checked: Bool = false
}

struct ShopLabel: Codable {
    let title: String
}

enum Priority: String, CaseIterable, Codable {
    case none = "None"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"
}
