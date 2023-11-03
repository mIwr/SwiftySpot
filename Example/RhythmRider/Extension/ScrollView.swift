//
//  ScrollView.swift
//  RhythmRider
//
//  Created by developer on 31.10.2023.
//

import SwiftUI

extension ScrollView {
    func onScroll(handler: @escaping (_ offset: CGPoint) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            let coordinateSpace = self.coordinateSpace(NamedCoordinateSpace.named(ScrollViewEventsNamespace._onScrollName))
            return coordinateSpace.onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: handler)
        } else {
            let coordinateSpace = self.coordinateSpace(name: ScrollViewEventsNamespace._onScrollName)
            return coordinateSpace.onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: handler)
        }
    }
}

struct ScrollOffsetTrackerView: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: ScrollOffsetPreferenceKey.self, value: CGPoint(x: -1.0 * geo.frame(in: .named(ScrollViewEventsNamespace._onScrollName)).origin.x, y: -1.0 * geo.frame(in: .named(ScrollViewEventsNamespace._onScrollName)).origin.y))
        }
        .frame(height: 0)
    }
}

fileprivate final class ScrollViewEventsNamespace {
    
    fileprivate static let _onScrollName = "ScrollView.Event.OnScroll"
    
    fileprivate init() {}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
