//
//  TaskDetailView.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 23.04.2023.
//

import SwiftUI

struct TaskDetailView: View {
    
    @State var isHover = false
    
    @State var newName: String = ""
    
    @ObservedObject var task: ModelCase
    @Environment(\.managedObjectContext) var managedObjContext
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                Image(systemName: "calendar")
                    .imageScale(.large)
                VStack(alignment: .leading) {
                    Text(task.when!, style: .date)
                    Text(task.when!, style: .time)
                }
                Spacer()
            }
            .padding(.horizontal)
            Divider()
            if let desc = task.desc, desc != "" {
                HStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .imageScale(.large)
                    Text(desc)
                        .font(.body)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            
        }
        .onAppear {
            newName = task.name!
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Image(systemName: task.done ? "checkmark.seal" : "xmark.seal")
                                .scaleEffect(isHover ? 1.2 : 1)
                                .onTapGesture {
                                    task.done.toggle()
                                    DataController().save(context: managedObjContext)
                                }
                                .onHover { isHover in
                                    self.isHover = isHover
                                }
                            TextField("Название", text: $newName)
                                .bold()
                                .onSubmit {
                                    if newName != "" {
                                        task.name = newName
                                        confirmChanges()
                                    }
                                }
                        }
                    }
            }
        }
    }
    private func confirmChanges() {
        if task.name != "" {
            MainNotifications.shared.removeNotification(with: task.id?.uuidString ?? "")
            DataController().save(context: managedObjContext)
            MainNotifications.shared.sendNotification(
                hour: Calendar.current.component(.hour, from: task.when!),
                minute: Calendar.current.component(.minute, from: task.when!),
                day: Calendar.current.component(.day, from: task.when!),
                task.name!,
                id: task.id?.uuidString ?? ""
            )
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}
