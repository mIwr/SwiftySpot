//
//  SPSearchPlaylist+Ctor.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

extension SPSearchPlaylist {
    
    public init(spotifyOwner: Bool, tracksCount: Int32, personalized: Bool) {
        self.ownedBySpotify = spotifyOwner
        self.tracksCount = tracksCount
        self.personalized = personalized
    }
    
}
