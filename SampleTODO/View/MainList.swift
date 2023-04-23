//
//  MainList.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 23.04.2023.
//

import SwiftUI

struct MainList: View {
    var model: FetchedResults<ModelCase>
    @Environment(\.managedObjectContext) var managedObjContext
    var body: some View {
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
    }
    private func deleteSpendings(offsets: IndexSet) {
        withAnimation {
            offsets.map { model[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}
