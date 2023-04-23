//
//  AddingView.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 22.04.2023.
//

import SwiftUI
import CoreHaptics

struct AddingView: View {
    
    @State private var engine: CHHapticEngine?
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.presentationMode) var presentationMode
    
    @State var taskName = ""
    @State var selectedDate = Date()
    @State var notificate = true
    @State var desc = ""

    var action: () -> ()
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Информация")) {
                        TextField("Название", text: $taskName)
                        TextField("Описание", text: $desc)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .keyboardType(.default)
                    }
                    Section(header: Text("Дата и время")) {
                        DatePicker("Дата и время", selection: $selectedDate, in: Date()...)
                    }
                    Section(header: Text("Добавление")) {
                        HStack {
                            Toggle("Напомнить", isOn: $notificate)
                                .toggleStyle(RadioToggleStyle())
                            Spacer()
                            Button(action: {
                                addButton()
                            }, label: {
                                Label("Добавить", systemImage: "square.and.arrow.down.on.square")
                            })
                        }
                    }
                }
                .navigationTitle("Новая задача")
            }
        }
        .onAppear(perform: prepareHaptics)
    }
    func addButton() {
        let id = UUID()
        if taskName != "" {
            complexSuccess()
            DataController().addCase(name: taskName, when: selectedDate, id: id, desc: desc,context: managedObjContext)
            print(DataController().container)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.action()
            }
            withAnimation {
                self.presentationMode.wrappedValue.dismiss()
            }
            if notificate {
                MainNotifications.shared.sendNotification(
                    hour: Calendar.current.component(.hour, from: selectedDate),
                    minute: Calendar.current.component(.minute, from: selectedDate),
                    day: Calendar.current.component(.day, from: selectedDate),
                    taskName,
                    id: id.uuidString
                )
            }
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
}

struct AddingView_Previews: PreviewProvider {
    static var previews: some View {
        AddingView(action: {})
    }
}

extension AddingView {
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensivity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensivity, sharpness], relativeTime: i)
            events.append(event)
        }
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensivity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensivity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
}


