//
//  OffsetObservingScrollView.swift
//  RhythmRider
//
//  Created by developer on 31.10.2023.
//

import SwiftUI

struct OffsetObservingScrollView<Content: View>: View {
    
    @State fileprivate(set) var maxScrollExtent: CGPoint = CGPoint()
    
    fileprivate let axes: Axis.Set
    fileprivate let showsIndicators: Bool
    fileprivate let onScroll: (_ offset: CGPoint, _ maxExtent: CGPoint) -> Void
    fileprivate let content: () -> Content
    
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        onScroll: ((_ offset: CGPoint, _ maxExtent: CGPoint) -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.onScroll = onScroll ?? { _, _ in }
        self.content = content
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ZStack(alignment: .top) {
                ScrollOffsetTrackerView()
                content()
                    .background(GeometryReader(content: { geo in
                        Color.clear.onAppear {
                            maxScrollExtent = CGPoint(x: geo.size.width, y: geo.size.height)
                        }
                    }))
            }
        }
        .onScroll(handler: { offset in
            onScroll(offset, maxScrollExtent)
        })
    }
}

struct OffsetObservingScrollView_Previews: PreviewProvider {

    fileprivate struct Preview: View {

        @State var scrollOffsetHorizontal: CGPoint = CGPoint()
        @State var scrollWidth: CGFloat = 0.0
        @State var scrollOffsetVertical: CGPoint = CGPoint()
        @State var scrollHeight: CGFloat = 0.0

        var body: some View {
            VStack {
                Text("Horizontal offset X \(Int(scrollOffsetHorizontal.x))")
                Text("Horizontal scroll max entent \(Int(scrollWidth))")
                OffsetObservingScrollView(.horizontal, showsIndicators: false, onScroll: {
                    offset, maxScrollExtent in
                    scrollOffsetHorizontal = offset
                    scrollWidth = maxScrollExtent.x
                }) {
                    LazyHStack {
                        ForEach(1...50, id: \.self) { index in
                            Divider()
                            Rectangle()
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(Color.blue)
                        }
                    }
                }
                .frame(height: 64)
                Divider()
                Text("Vertical scroll offset Y \(Int(scrollOffsetVertical.y))")
                Text("Vertical scroll max extent \(Int(scrollHeight))")
                OffsetObservingScrollView(onScroll: {
                    offset, maxScrollExtent in
                    scrollOffsetVertical = offset
                    scrollHeight = maxScrollExtent.y
                }) {
                    LazyVStack {
                        ForEach(1...100, id: \.self) {
                            Divider()
                            Text("\($0)")
                        }
                    }
                }
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}
