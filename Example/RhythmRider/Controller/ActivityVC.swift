//
//  ActivityVC.swift
//  RhythmRider
//
//  Created by developer on 27.10.2023.
//

import SwiftUI

///Shows share activity controller through SwiftUI modifiers (fullscreen modal)
struct ActivityVC: UIViewControllerRepresentable {
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    @Binding var presented: Bool
    
    init(presented: Binding<Bool>, activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        _presented = presented
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityVC>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            presented = false
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityVC>) {
        
    }
}
