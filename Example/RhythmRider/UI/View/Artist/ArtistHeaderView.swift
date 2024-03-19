//
//  ArtistHeaderView.swift
//  RhythmRider
//
//  Created by developer on 18.12.2023.
//

import SwiftUI
import SwiftySpot

struct ArtistHeaderView: View {
    
    @EnvironmentObject var api: ApiController
    
    let uri: String
    let name: String
    let genres: [String]
    let img: UIImage?
    
    @State var like: Bool
    @State var dislike: Bool
    
    init(uri: String, name: String, genres: [String], img: UIImage?) {
        self.uri = uri
        self.name = name
        self.genres = genres
        self.img = img
        
        self._like = State(initialValue: false)
        self._dislike = State(initialValue: false)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12, content: {
            Image(uiImage: img ?? R.image.icUser() ?? UIImage())
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(12)
            VStack(alignment: .leading, spacing: 4, content: {
                Text(name)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.leading)
                if (!genres.isEmpty) {
                    Text(genres.joined(separator: ", "))
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                HStack(alignment: .top, spacing: 0, content: {
                    Button(action: {
    #if DEBUG
                        if (ProcessInfo.processInfo.previewMode) {
                            //Disable real API request and override validation
                            like = !like
                            return
                        }
    #endif
                        if (!SPNavigateUriUtil.validateArtistUri(uri)) {
                            return
                        }
                        like = !like
                        if (!like) {
                            //liked before toggle -> remove like
                            api.client.removeArtistLike(uri: uri) { _ in
                                //If fails, the reset update will be received through notification center
                            }
                        } else {
                            //liked after toggle -> like cmd
                            api.client.likeArtist(uri: uri) { _ in
                                //If fails, the reset update will be received through notification center
                            }
                            if (api.client.dislikedArtistsStorage.find(uri: uri) != nil) {
                                api.client.removeArtistDislike(uri: uri) { _ in
                                }
                            }
                        }
                    }, label: {
                        Image(like
                              ? R.image.icHeartFill
                              : R.image.icHeart)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(R.color.error))
                    })
                    .frame(width: 32, height: 32, alignment: .center)
                    Spacer(minLength: 16)
                    Button(action: {
    #if DEBUG
                        if (ProcessInfo.processInfo.previewMode) {
                            //Disable real API request and override validation
                            dislike = !dislike
                            return
                        }
    #endif
                        if (!SPNavigateUriUtil.validateArtistUri(uri)) {
                            return
                        }
                        dislike = !dislike
                        if (!dislike) {
                            //disliked before toggle -> remove dislike
                            api.client.removeArtistDislike(uri: uri) { _ in
                                //If fails, the reset update will be received through notification center
                            }
                        } else {
                            //disliked after toggle -> dislike cmd
                            api.client.dislikeArtist(uri: uri) { dislikeRes in
                                //If fails, the reset update will be received through notification center
                            }
                            if (api.client.likedArtistsStorage.find(uri: uri) != nil) {
                                api.client.removeArtistLike(uri: uri) { _ in
                                    
                                }
                            }
                        }
                    }, label: {
                        Image(dislike
                              ? R.image.icHeartOffFill
                              : R.image.icHeartOff)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(Color(R.color.primary))
                    }).frame(width: 32, height: 32, alignment: .center)
                })
            })
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear(perform: {
            like = api.client.likedArtistsStorage.find(uri: uri) != nil
            dislike = api.client.dislikedArtistsStorage.find(uri: uri) != nil
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPArtistLikeUpdate), perform: { notification in
            let parsed = notification.tryParseArtistLikeUpdate()
            guard let item = parsed.1, parsed.0 else {return}
            if (uri != item.uri) {
                return
            }
            like = !item.removed && item.addedTs > 0
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPArtistDislikeUpdate), perform: { notification in
            let parsed = notification.tryParseArtistDislikeUpdate()
            guard let item = parsed.1, parsed.0 else {return}
            if (uri != item.uri) {
                return
            }
            dislike = !item.removed && item.addedTs > 0
        })
    }
}

#Preview {
    @StateObject var api: ApiController = ApiController(previewApiClient)
    return ArtistHeaderView(uri: "sp:123", name: "Artist long-long-long-long name", genres: ["Pop", "Rock"], img: nil)
        .environmentObject(api)
}
