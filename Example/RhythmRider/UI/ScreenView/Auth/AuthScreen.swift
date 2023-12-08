//
//  AuthScreen.swift
//  RhythmRider
//
//  Created by Developer on 09.10.2023.
//

import SwiftUI
import SwiftySpot

struct AuthScreen: View {
    
    @EnvironmentObject var api: ApiController
    
    @State fileprivate var _login = ""
    @State fileprivate var _pass = ""
    @State fileprivate var _processing = false
    @State fileprivate var _err = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8)
        {
            VStack(alignment: .center, spacing: 0, content: {
                Image(uiImage: R.image.appIconRounded() ?? UIImage())
                    .resizable().scaledToFit()
                    .frame(width: 128, height: 128)
            })
            .frame(maxWidth: .infinity)
            Spacer(minLength: 24)
            Text(R.string.localizable.authLoginTitle())
                .font(.title3.weight(.semibold))
                .foregroundColor(Color(R.color.primary))
                .alignmentGuide(.leading) { _ in 0 }
            TextField(R.string.localizable.authLoginTitle(), text: $_login)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 16, trailing: 0))
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .onTapGesture {
                    _err = ""
                }
            Text(R.string.localizable.generalPassword())
                .font(.title3.weight(.semibold))
            SecureTextFieldWithReveal(key: R.string.localizable.generalPassword(), text: $_pass)
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                .onTapGesture {
                    _err = ""
                }
            Spacer(minLength: 16)
            VStack(alignment: .center, spacing: 12, content: {
                Text(_err)
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color(R.color.error))
                    .multilineTextAlignment(.leading)
                Button(action: {
                    if (_processing) {
                        return
                    }
                    if (_login.isEmpty) {
                        _err = R.string.localizable.authLoginEmptyLogin()
                        return
                    } else if (_pass.isEmpty) {
                        _err = R.string.localizable.authLoginEmptyPassword()
                        return
                    }
                    _err = ""
                    _processing = true
    #if DEBUG
                    if (ProcessInfo.processInfo.previewMode) {
                        //Disable real API request
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            _err = "Preview mode err"
                            _processing = false
                        }
                        return
                    }
    #endif
                    _ = api.client.auth(login: _login, password: _pass) { result in
                        _processing = false
                        switch (result) {
                        case .success(let session):
                            if (session.token.isEmpty) {
                                _err = R.string.localizable.authLoginNoAuthToken()
                                return
                            }
                        case .failure(let error):
                            _err = error.errorDescription
                        }
                    }
                }) {
                    if (_processing) {
                        ProgressView().progressViewStyle(.circular)
                    } else {
                        Text(R.string.localizable.authLoginSignIn())
                            .font(.headline)
                            .foregroundColor(Color(R.color.primary))
                    }
                }
                .buttonStyle(AccentWideButtonStyle())
            })
            .frame(maxWidth: .infinity, minHeight: Constants.defaultButtonHeight * 2, alignment: .bottom)
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 16))
        .background(Color(R.color.bgPrimary).ignoresSafeArea(edges: .all))
        .alignmentGuide(.top, computeValue: { dimension in
            return 0
        })
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    return AuthScreen().environmentObject(api)
}
