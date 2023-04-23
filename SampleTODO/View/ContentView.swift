//
//  ContentView.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 22.04.2023.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @State private var showAddingView = false
    
    @Environment(\.requestReview) var requestReview
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.when, order: .reverse)]) var model: FetchedResults<ModelCase>
    var body: some View {
        
        NavigationStack {
            VStack {
                if !model.isEmpty {
                    List {
                        ForEach(model) { task in
                            TaskCell(task: task)
                        }
                        .onDelete(perform: deleteSpendings)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddingView.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                    }

                }
            }
            .sheet(isPresented: $showAddingView) {
                AddingView {
                    if self.model.count % 5 == 0 {
                        requestReview()
                    }
                }
            }
            .navigationTitle("Задачник")
        }
    }
    private func deleteSpendings(offsets: IndexSet) {
        withAnimation {
            offsets.map { model[$0] }
            .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
