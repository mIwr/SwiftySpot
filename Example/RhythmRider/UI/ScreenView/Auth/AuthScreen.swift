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
    
    static fileprivate let _authTypePass = 0
    static fileprivate let _authTypeStoredCred = 1
    
    @State fileprivate var _authType = 0
    fileprivate var _passAuth: Bool {
        get {
            return _authType == AuthScreen._authTypePass
        }
    }
    fileprivate var _storedCredAuth: Bool {
        get {
            return _authType == AuthScreen._authTypeStoredCred
        }
    }
    @State fileprivate var _login = ""
    @State fileprivate var _pass = ""
    @State fileprivate var _storedCred = ""
    @State fileprivate var _processing = false
    @State fileprivate var _err = ""
    
    var body: some View {
        ZStack(content: {
            Form(content: {})
                .background(Color(R.color.bgPrimary).ignoresSafeArea(edges: .all))
                .alignmentGuide(.top, computeValue: { dimension in
                    return 0
                })
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            VStack(alignment: .leading, spacing: 8)
            {
                VStack(alignment: .center, spacing: 0, content: {
                    Image(uiImage: R.image.appIconRounded() ?? UIImage())
                        .resizable().scaledToFit()
                        .frame(width: 128, height: 128)
                })
                .frame(maxWidth: .infinity)
                Text(R.string.localizable.authLoginTitle())
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color(R.color.primary))
                    .alignmentGuide(.leading) { _ in 0 }
                TextField(R.string.localizable.authLoginTitle(), text: $_login)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 16, trailing: 0))
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .onTapGesture {
                        _err = ""
                    }
                Picker(R.string.localizable.authType(), selection: $_authType) {
                    Text(R.string.localizable.authTypePass()).tag(AuthScreen._authTypePass)
                    Text(R.string.localizable.authTypeStoredCred()).tag(AuthScreen._authTypeStoredCred)
                }
                .pickerStyle(.segmented)
                if (_passAuth) {
                    Text(R.string.localizable.generalPassword())
                        .font(.title3.weight(.semibold))
                    SecureTextFieldWithReveal(key: R.string.localizable.generalPassword(), text: $_pass)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                        .onTapGesture {
                            _err = ""
                        }
                } else if (_storedCredAuth) {
                    Text(R.string.localizable.authTypeStoredCred())
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Color(R.color.primary))
                        .alignmentGuide(.leading) { _ in 0 }
                    TextEditor(text: $_storedCred)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(R.color.bgSecondary), lineWidth: 1.0)
                        )
                        .onTapGesture {
                            _err = ""
                        }
                        .frame(minHeight: 80, maxHeight: 160)
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
                        }
                        if (_passAuth && _pass.isEmpty) {
                            _err = R.string.localizable.authLoginEmptyPassword()
                            return
                        } else if (_storedCredAuth && _storedCred.isEmpty) {
                            _err = R.string.localizable.authLoginEmptyStoredCred()
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
                        let completion: ((Result<SPAuthSession, SPError>) -> Void) = {
                            result in
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
                        if (_storedCredAuth) {
                            _ = api.client.auth(login: _login, storedCredential: _storedCred, completion: completion)
                            return
                        }
                        _ = api.client.auth(login: _login, password: _pass, completion: completion)
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
        })
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    return AuthScreen().environmentObject(api)
}
