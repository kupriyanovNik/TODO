//
//  Extensions.swift
//  SampleTODO
//
//  Created by Никита Куприянов on 23.04.2023.
//

import SwiftUI

extension Binding where Value: Equatable {
    static func bindOptional(_ source: Binding<Value?>, _ defaultValue: Value) -> Binding<Value> {
        self.init(get: {
            source.wrappedValue ?? defaultValue
        }, set: {
            source.wrappedValue = ($0 as? String) == "" ? nil : $0
        })
    }
}

struct RadioToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.gray.opacity(0.2))
            Button {
                configuration.isOn.toggle()
            } label: {
                Label {
                    configuration.label
                        .padding(.horizontal, 0)
                } icon: {
                    Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                        .imageScale(.large)
                        .padding(.horizontal, 0)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: UIScreen.main.bounds.width / 2.6)
    }
}
