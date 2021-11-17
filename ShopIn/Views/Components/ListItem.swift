//
//  ListItem.swift
//  ShopIn
//
//  Created by Matteo on 14/11/2021.
//

import SwiftUI

struct ListItem: View {
    @Binding var item: ShopModel
    
    @EnvironmentObject var viewModel: ShopViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: item.checked ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 30))
                .foregroundColor(viewModel.getPriorityColor(item.priority))
            VStack(alignment: .leading) {
                HStack {
                    Text(item.content)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(item.checked ? Color(uiColor: .systemGray) : Color.primary)
                    Text("\(item.quantity)")
                        .font(.system(size: 18))
                        .foregroundColor(Color(uiColor: .systemGray))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(uiColor: .systemGray).opacity(0.2))
                        .cornerRadius(10)
                    Spacer()
                    if item.priority != .none {
                        Image(systemName: "circle.fill")
                            .foregroundColor(viewModel.getPriorityColor(item.priority))
                    }
                }
                HStack {
                    if !item.store.isEmpty {
                        Text(item.store)
                    }
                    if !item.store.isEmpty && item.reminder != nil {
                        Text("-")
                    }
                    if item.reminder != nil {
                        Text(viewModel.getTime(item.reminder!))
                    }
                }
                .foregroundColor(Color(uiColor: .systemGray))
                HStack {
                    if item.amount > 0.00 {
                        Text("€\(viewModel.getPrice(item.amount, quantity: item.quantity), specifier: "%.2f")")
                            .font(.system(size: 18))
                            .foregroundColor(Color(uiColor: item.checked ? .systemGray : .systemGreen))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color(uiColor: item.checked ? .systemGray : .systemGreen).opacity(0.2))
                            .cornerRadius(10)
                    }
                    if !item.label.isEmpty {
                        Text(item.label)
                            .font(.system(size: 18))
                            .foregroundColor(Color(uiColor: item.checked ? .systemGray : .systemPurple))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color(uiColor: item.checked ? .systemGray : .systemPurple).opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .contextMenu {
            !item.checked ? menuItems : nil
        }
        .padding(.vertical, 10)
        .onTapGesture {
            withAnimation {
                item.checked.toggle()
            }
            viewModel.handleItem(item)
        }
        .background(Color(uiColor: .systemBackground))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var menuItems: some View {
        Group {
            Button {
                viewModel.item = item
                viewModel.showEditSheet.toggle()
            }
            label: {
                Label {
                    Text("Edit \(item.content)")
                } icon: {
                    Image(systemName: "pencil")
                }
            }
            
            Button(role: .destructive) {
                viewModel.removeItem(item)
            } label: {
                Label {
                    Text("Remove \(item.content)")
                } icon: {
                    Image(systemName: "trash")
                }
            }

        }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
