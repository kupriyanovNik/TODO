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
    
    var formatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter
    }
    
    var body: some View {
            HStack {
                Image(systemName: task.done ? "checkmark.seal" : "xmark.seal")
                    .bold()
                VStack(alignment: .leading) {
                    if let name = task.name {
                        Text(name)
                            .font(.title3)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.mint)
                            .bold()
                    }
                }
                Spacer()
                if let when = task.when {
                    NavigationLink {
                        TaskDetailView(task: task)
                    } label: {
                        HStack {
                            Spacer()
                            if Calendar.current.isDateInToday(when) {
                                Text(when, style: .time)
                                    .bold()
                                    .foregroundColor(.gray)
                            } else {
                                Text(formatter.string(from: when))
                                    .foregroundColor(.gray)
                            }
                        }
                    }.frame(alignment: .trailing)
                }


            }
            .frame(maxWidth: .infinity)
            .contextMenu {
                Button {
                    self.task.done.toggle()
                    DataController().save(context: managedObjContext)
                } label: {
                    Label(self.task.done ? "Не сделано" : "Сделано", systemImage: self.task.done ? "xmark" : "checkmark").bold()
                }

            }
    }
    func toggleDone() {
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
    }
}

//struct TaskCell_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskCell(name: "create an app", when: Date(), done: .constant(true))
//            .previewLayout(.sizeThatFits)
//    }
//}
