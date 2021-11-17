//
//  EditItemView.swift
//  ShopIn
//
//  Created by Matteo on 15/11/2021.
//

import SwiftUI

struct EditItemView: View {
    
    @EnvironmentObject var viewModel: ShopViewModel
    @FocusState var focusContentField: Bool
    @State var showAlert = false
    @State var prioritySelected: String = Priority.none.rawValue
    @State var isReminder = false
    @State var dateReminder = Date()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack(spacing: 20) {
                            Text("Item")
                                .frame(width: 70, alignment: .leading)
                            TextField("Eggs", text: $viewModel.item.content)
                                .focused($focusContentField)
                        }
                        
                        HStack(spacing: 20) {
                            Text("Quantity")
                                .frame(width: 70, alignment: .leading)
                            TextField("Quantity", value: $viewModel.item.quantity, format: .number, prompt: Text("€0.00"))
                                .keyboardType(.decimalPad)
                        }
                        
                    }
                    
                    Section {
                        HStack(spacing: 20) {
                            Text("Amount")
                                .frame(width: 70, alignment: .leading)
                            TextField("Amount", value: $viewModel.item.amount, format: .currency(code: Locale.current.currencyCode ?? "EUR"))
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
                            TextField("Apple pie ingredients", text: $viewModel.item.label)
                        }
                        HStack(spacing: 20) {
                            Text("Store")
                                .frame(width: 70, alignment: .leading)
                            TextField("WallMart", text: $viewModel.item.store)
                        }
                    } header: {
                        Text("Informations")
                    }
                    footer: {
                        Text("Add informations to be more precise")
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Item is missing"), message: Text("You have to enter an item"), dismissButton: .cancel())
                }
            }
            .onAppear {
                prioritySelected = viewModel.item.priority.rawValue
                dateReminder = viewModel.item.reminder ?? Date()
            }
            .animation(.spring(), value: isReminder)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showEditSheet.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print(viewModel.item)
                        viewModel.updateItem()
                        viewModel.showEditSheet.toggle()
                    } label: {
                        Text("Done")
                    }
                }
            })
            .navigationTitle("Add Item")
        }
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView()
            .environmentObject(ShopViewModel())
    }
}
