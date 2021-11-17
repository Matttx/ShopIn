//
//  ShopViewModel.swift
//  ShopIn
//
//  Created by Matteo on 14/11/2021.
//

import Foundation
import SwiftUI

class ShopViewModel: ObservableObject {
    @Published var shopList: [ShopModel] = [] {
        didSet {
            saveShopListToLocalStorage()
        }
    }
    
    @Published var completedList: [ShopModel] = [] {
        didSet {
            saveCompletedListToLocalStorage()
        }
    }
    
    @Published var item: ShopModel = ShopModel(content: "")
    
    @Published var showAddSheet = false
    @Published var showEditSheet = false
    
    init() {
        getShopListFromLocalStorage()
        getCompletedListFromLocalStorage()
    }
    
    //MARK: - Item functions
    
    func removeItem(_ item: ShopModel) {
        if let index = shopList.firstIndex(where: {$0.id == item.id}) {
            shopList.remove(at: index)
        }
    }
    
    //MARK: - EditView functions
    
    func updateItem() {
        if let index = shopList.firstIndex(where: {$0.id == item.id}) {
            shopList[index] = item
        }
    }
    
    //MARK: - List functions

    func handleItem(_ item: ShopModel) {
        // Set item in the completed list
        if item.checked {
            shopList = shopList.filter {$0.content != item.content}
            completedList.append(item)
        }
        // Remove item from the completed list
        else {
            completedList = completedList.filter {$0.content != item.content}
            shopList.append(item)
        }
    }
    
    //MARK: - Save datas to the localstorage
    
    func saveShopListToLocalStorage() {
        do {
            let encoder = JSONEncoder()
            
            let shopList = try encoder.encode(shopList)
            
            UserDefaults.standard.set(shopList, forKey: "shopList")
        }
        catch {
            print("Unable to encode shopList")
        }
    }
    
    func saveCompletedListToLocalStorage() {
        do {
            let encoder = JSONEncoder()
            
            let completedList = try encoder.encode(completedList)
            
            UserDefaults.standard.set(completedList, forKey: "completedList")
        }
        catch {
            print("Unable to encode completedList")
        }
    }
    
    func getShopListFromLocalStorage() {
        if let data = UserDefaults.standard.data(forKey: "shopList") {
            do {
                let decoder = JSONDecoder()
                
                let shopList = try decoder.decode([ShopModel].self, from: data)
                
                self.shopList = shopList
            } catch {
                print("Unable to decode shopList")
            }
        }
    }
    
    func getCompletedListFromLocalStorage() {
        if let data = UserDefaults.standard.data(forKey: "completedList") {
            do {
                let decoder = JSONDecoder()
                
                let completedList = try decoder.decode([ShopModel].self, from: data)
                
                self.completedList = completedList
            } catch {
                print("Unable to decode completedList")
            }
        }
    }
    
    //MARK: - Utils
    
    func getPriorityColor(_ priority: Priority) -> Color {
        switch priority {
            case .none:
                return Color(uiColor: .systemBlue)
            case .low:
                return Color(uiColor: .systemGreen)
            case .medium:
                return Color(uiColor: .systemOrange)
            case .high:
                return Color(uiColor: .systemRed)
            case .urgent:
                return Color.primary
        }
    }
    
    func getTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd MMM yy"
        return dateFormatter.string(from: date)
    }
    
    func getPrice(_ price: Double, quantity: Int) -> Double {
        return price * Double(quantity)
    }
    
    func getTotal() -> Double {
        var total = 0.0
        
        for item in shopList {
            total += getPrice(item.amount, quantity: item.quantity)
        }
        return total
    }
}
