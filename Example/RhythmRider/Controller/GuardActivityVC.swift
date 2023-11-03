//
//  ActivityViewScreen.swift
//  RhythmRider
//
//  Created by developer on 27.10.2023.
//

import SwiftUI

///Shows share activity controller through through UIKit VController placeholder 
struct GuardActivityVC: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    @Binding var presented: Bool
    
    init(presented: Binding<Bool>, activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        _presented = presented
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewControllerHost {
        let result = UIActivityViewControllerHost()
        result.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            presented = false
        }
        return result
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewControllerHost, context: Context) {
        // Update the text in the hosting controller
        uiViewController.activityItems = activityItems
        uiViewController.applicationActivities = applicationActivities
    }
}

class UIActivityViewControllerHost: UIViewController {
    var activityItems: [Any] = []
    var applicationActivities: [UIActivity]? = nil
    var completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        share()
    }
    
    fileprivate func share() {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = completionWithItemsHandler
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
}
