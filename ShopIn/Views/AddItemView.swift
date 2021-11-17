//
//  AddItemView.swift
//  ShopIn
//
//  Created by Matteo on 15/11/2021.
//

import SwiftUI

struct AddItemView: View {
    
    @State var contentField = ""
    @State var amount: Double = 0.0
    @State var quantity = 1
    @FocusState var focusContentField: Bool
    @State var prioritySelected = Priority.none.rawValue
    @State var isReminder = false
    @State var dateReminder = Date()
    @State var label = ""
    @State var store = ""
    @State var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: ShopViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack(spacing: 20) {
                            Text("Item")
                                .frame(width: 70, alignment: .leading)
                            TextField("Eggs", text: $contentField)
                                .focused($focusContentField)
                        }
                        
                        HStack(spacing: 20) {
                            Text("Quantity")
                                .frame(width: 70, alignment: .leading)
                            TextField("Quantity", value: $quantity, format: .number, prompt: Text("WOW"))
                                .keyboardType(.decimalPad)
                        }
                        
                    }
                    
                    Section {
                        HStack(spacing: 20) {
                            Text("Amount")
                                .frame(width: 70, alignment: .leading)
                            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "EUR"))
                                .keyboardType(.decimalPad)
                        }
                    } footer: {
                        Text("Add the amount of one item")
                    }
                    
                    Section {
                        Picker("Priority", selection: $prioritySelected) {
                            ForEach(Priority.allCases, id: \.rawValue) {
                                Text($0.rawValue)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    } header: {
                        Text("item priority")
                    }
                    
                    Section {
                        Toggle("Do you want a reminder ?", isOn: $isReminder)
                        if isReminder {
                            DatePicker("Select a date", selection: $dateReminder)
                        }
                    } header: {
                        Text("Reminder")
                    }
                    
                    Section {
                        HStack(spacing: 20) {
                            Text("Label")
                                .frame(width: 70, alignment: .leading)
                            TextField("Apple pie ingredients", text: $label)
                        }
                        HStack(spacing: 20) {
                            Text("Store")
                                .frame(width: 70, alignment: .leading)
                            TextField("WallMart", text: $store)
                        }
                    } header: {
                        Text("Informations")
                    } footer: {
                        Text("Add informations to be more precise")
                    }
                    
                    Section {
                        Button {
                            if contentField.isEmpty {
                                showAlert.toggle()
                                return
                            }
                            let item = ShopModel(content: contentField, quantity: quantity, label: label, priority: Priority(rawValue: prioritySelected)!, reminder: isReminder ? dateReminder : nil, store: store, amount: amount, checked: false)
                            viewModel.shopList.append(item)
                            dismiss()
                        } label: {
                            Text("Add item")
                                .foregroundColor(Color.white)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .listRowBackground(Color(uiColor: .systemBlue))
                    .listRowInsets(EdgeInsets())
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Item is missing"), message: Text("You have to enter an item"), dismissButton: .cancel())
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                })
                .navigationTitle("Add Item")
            }
            .animation(.spring(), value: isReminder)
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
