//
//  ContentView.swift
//  ShopIn
//
//  Created by Matteo on 14/11/2021.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = ShopViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Section {
                    if viewModel.shopList.isEmpty {
                        Text("Add your first item 😄")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    }
                    ForEach($viewModel.shopList, id: \.id) { item in
                        ListItem(item: item)
                            .environmentObject(viewModel)
                    }
                } header: {
                    if !viewModel.shopList.isEmpty {
                        HStack {
                            Text("Total: €\(viewModel.getTotal(), specifier: "%.2f")")
                                .foregroundColor(Color(uiColor: .systemGray))
                            Spacer()
                            if viewModel.shopList.count > 0 {
                                Button {
                                    viewModel.shopList = []
                                } label: {
                                    Text("Clear")
                                }
                            }
                        }
                    }
                }
                if !viewModel.completedList.isEmpty {
                    Section {
                        ForEach($viewModel.completedList, id: \.id) { item in
                            ListItem(item: item)
                                .environmentObject(viewModel)
                        }
                    } header: {
                        HStack {
                            Text("Completed")
                                .foregroundColor(Color(uiColor: .systemGray))
                            Spacer()
                            if viewModel.completedList.count > 0 {
                                Button {
                                    viewModel.completedList = []
                                } label: {
                                    Text("Clear")
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddItemView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $viewModel.showEditSheet) {
                EditItemView()
                    .environmentObject(viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showAddSheet.toggle()
                    } label: {
                        Text("Add")
                    }

                }
            }
            .navigationTitle("ShopIn")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
