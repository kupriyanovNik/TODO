//
//  TaskCell.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 22.04.2023.
//

import SwiftUI

struct TaskCell: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @ObservedObject var task: ModelCase
    var body: some View {
        VStack {
            HStack {
                Button {
                    if task.done {
                        task.done = false
                        MainNotifications.shared.sendNotification(
                            hour: Calendar.current.component(.hour, from: task.when!),
                            minute: Calendar.current.component(.minute, from: task.when!),
                            day: Calendar.current.component(.day, from: task.when!),
                            task.name ?? "",
                            id: task.id?.uuidString ?? "")
                    } else {
                        task.done = true
                        MainNotifications.shared.removeNotification(with: task.id?.uuidString ?? "")
                    }
                    do {
                        try managedObjContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Image(systemName: task.done ? "checkmark.seal" : "xmark.seal")
                }

                if let name = task.name {
                    Text(name)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.mint)
                        .bold()
                        .font(.title3)
                }
                Spacer()
                if let when = task.when {
                    VStack {
                        Text(when, style: .date)
                        Text(when, style: .time)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

//struct TaskCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCell(name: "create an app", when: Date(), done: .constant(true))
//            .previewLayout(.sizeThatFits)
//    }
//}
