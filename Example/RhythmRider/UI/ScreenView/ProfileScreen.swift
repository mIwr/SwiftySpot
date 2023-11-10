//
//  ProfileScreen.swift
//  RhythmRider
//
//  Created by developer on 30.10.2023.
//

import SwiftUI
import SwiftySpot

struct ProfileScreen: View {
    
    @EnvironmentObject var api: ApiController
    @EnvironmentObject var appProperties: AppProperties
    
    @State fileprivate var _loaded: Bool?
    @State fileprivate var _confirmLogoutAlertShow: Bool
    
    fileprivate var _profileInfo: ProfileInfoVModel
    
    init() {
        __loaded = State(initialValue: nil)
        __confirmLogoutAlertShow = State(initialValue: false)
        _profileInfo = ProfileInfoVModel(profile: nil)
    }
    
    var body: some View {
        VStack(content: {
            if _loaded == true, let safeProfile = _profileInfo.profile  {
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .center, spacing: 0, content: {
                            Image(R.image.icProfile)
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .center)
                                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                .background(Color(R.color.bgSecondary))
                                .cornerRadius(64)
                            VStack(alignment: .leading, spacing: 0, content: {
                                Text(safeProfile.displayName)
                                    .font(.headline).fontWeight(.semibold)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color(R.color.primary))
                                if (!safeProfile.email.isEmpty) {
                                    Text(safeProfile.email)
                                        .font(.subheadline).fontWeight(.regular)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(Color(R.color.secondary))
                                }
                                
                            })
                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                        ProfileInfoComponentView(category: "ID", value: safeProfile.id)
                        ProfileInfoComponentView(category: R.string.localizable.profileCountry(), value: Locale.current.localizedString(forRegionCode: safeProfile.country) ?? safeProfile.country)
                        ProfileInfoComponentView(category: R.string.localizable.profileSubscriptionPlan(), value: safeProfile.product)
                        ProfileToggleSettingView(title: R.string.localizable.profileTrafficEconomyTitle(), subtitle: R.string.localizable.profileTrafficEconomySubtitle(), initValue: appProperties.trafficEconomy) { newVal in
                            appProperties.trafficEconomy = newVal
                            appProperties.save()
                        }
                        ProfileToggleSettingView(title: R.string.localizable.profileSkipDislikedTitle(), subtitle: R.string.localizable.profileSkipDislikedSubtitle(), initValue: appProperties.playbackSkipDisliked) { newVal in
                            appProperties.playbackSkipDisliked = newVal
                            appProperties.save()
                        }
                    }
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
            } else {
                LoadingView()
            }
        })
        .navigationTitle(R.string.localizable.generalProfile())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    _confirmLogoutAlertShow = !_confirmLogoutAlertShow
                }, label: {
                    Image(R.image.icLogout)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })
                .frame(width: 24, height: 24)
                .alert(isPresented: $_confirmLogoutAlertShow, content: {
                    Alert(title: Text(R.string.localizable.alertConfirmTitle()), message: Text(R.string.localizable.alertConfirmSubtitle()),
                          primaryButton: .destructive(
                                    Text(R.string.localizable.generalLogout()),
                                    action: {
                                        #if DEBUG
                                        if (ProcessInfo.processInfo.previewMode) {
                                            //Disable real api request
                                            return
                                        }
                                        #endif
                                        api.client.logout(dropClSession: true)
                                    }
                                ),
                          secondaryButton: .cancel(
                                    Text(R.string.localizable.generalCancel()),
                                    action: {}
                                )
                            )
                })
            }
        }
        .onAppear(perform: {
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    _profileInfo.profile = SPProfile(id: "someID", type: "user", email: "email@eail.com", displayName: "Display name", birthdate: "01-01-1970", extUrls: [:], href: "", images: [], country: "DE", product: "free", explicitContent: SPExplicit(enabled: true, locked: false), policies: nil)
                    _loaded = true
                }
                return
            }
#endif
            if let safeProfile = api.client.me {
                _profileInfo.profile = safeProfile
                _loaded = true
                return
            }
            Task {
                _loaded = await loadData()
            }
        })
    }
    
    fileprivate func loadData() async -> Bool {
        return await withCheckedContinuation { continuation in
            api.client.getProfileInfo { result in
                do {
                    let info = try result.get()
                    self._profileInfo.profile = info
                    continuation.resume(returning: true)
                } catch {
                    continuation.resume(returning: false)
                }
            }
        }
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    return NavigationView(content: {
        ProfileScreen()
    })
    .environmentObject(api)
    .environmentObject(previewProperties)
}
