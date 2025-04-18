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
    static fileprivate let _authTypeMagicLink = 2
    
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
    fileprivate var _magicLinkAuth: Bool {
        get {
            return _authType == AuthScreen._authTypeMagicLink
        }
    }
    @State fileprivate var _login = ""
    @State fileprivate var _pass = ""
    @State fileprivate var _storedCred = ""
    @State fileprivate var _magicLink = ""
    @State fileprivate var _processing = false
    @State fileprivate var _err = ""
    
    @StateObject fileprivate var _authInitMeta = AuthInitMetaVModel()
    @State fileprivate var _showChallengeSheet = false
    @State fileprivate var _passedChallengeInteractRef = ""
    
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
                    Text(R.string.localizable.authTypeMagicLink()).tag(AuthScreen._authTypeMagicLink)
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
                } else if (_magicLinkAuth) {
                    HStack {
                        Spacer()
                        Button(action: {
                            if (_processing || !_passedChallengeInteractRef.isEmpty) {
                                return
                            }
                            if (_login.isEmpty) {
                                _err = R.string.localizable.authLoginEmptyLogin()
                                return
                            }
                            _ = api.client.initAuth(login: _login, password: nil, completion: { result in
                                switch (result) {
                                case .success(let authInit):
                                    DispatchQueue.main.async {
                                        _authInitMeta.authInitMeta = authInit
                                        _magicLink = ""
                                    }
                                    break
                                case .failure(let err):
                                    authComepltion(.failure(err))
                                    return
                                }
                            })
                        }) {
                            Text(R.string.localizable.authLoginMagicLinkInit())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(R.string.localizable.authLoginMagicLinkTitle())
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Color(R.color.primary))
                        .alignmentGuide(.leading) { _ in 0 }
                    TextEditor(text: $_magicLink)
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
                        if (_processing || !_passedChallengeInteractRef.isEmpty) {
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
                        if (_storedCredAuth) {
                            _ = api.client.auth(login: _login, storedCredential: _storedCred, completion: authComepltion)
                            return
                        }
                        if (_magicLinkAuth) {
                            if (_magicLink.isEmpty) {
                                _err = R.string.localizable.authLoginEmptyMagicLink()
                                _processing = false
                                return
                            }
                            _ = api.client.authWithMagicLink(_magicLink, authInitMeta: _authInitMeta.authInitMeta, completion: authComepltion)
                            return
                        }
                        _ = api.client.initAuth(login: _login, password: _pass, completion: { result in
                            switch (result) {
                            case .success(let authInit):
                                DispatchQueue.main.async {
                                    _authInitMeta.authInitMeta = authInit
                                    _showChallengeSheet = true
                                }
                                break
                            case .failure(let err):
                                authComepltion(.failure(err))
                                return
                            }
                        })
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
                    .sheet(isPresented: $_showChallengeSheet) {
                        _showChallengeSheet = false
                        if (_passedChallengeInteractRef.isEmpty) {
                            _err = R.string.localizable.authLoginChallengePassFail()
                            _processing = false
                            return
                        }
                        guard let safeCaptcha = _authInitMeta.authInitMeta.captcha else {
                            _err = R.string.localizable.authLoginChallengePassFail()
                            _processing = false
                            return
                        }
                        _ = api.client.authWithCaptcha(login: _login, password: _pass, authInitMeta: _authInitMeta.authInitMeta, loginContext: safeCaptcha.context, challengeInteractRef: _passedChallengeInteractRef, completion: authComepltion)
                    } content: {
                        CaptchaChallengeScreen(presented: $_showChallengeSheet, interactRef: $_passedChallengeInteractRef, challengeUrl: _authInitMeta.challengeUrl, callbackUrl: _authInitMeta.authInitMeta.callbackUrl)
                    }

                })
                .frame(maxWidth: .infinity, minHeight: Constants.defaultButtonHeight * 2, alignment: .bottom)
            }
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 16))
        })
    }
    
    fileprivate func authComepltion(_ result: Result<SPAuthSession, SPError>) {
        _processing = false
        _passedChallengeInteractRef = ""
        switch (result) {
        case .success(let session):
            if (session.token.isEmpty) {
                _err = R.string.localizable.authLoginNoAuthToken()
                return
            }
        case .failure(let error):
            _authInitMeta.authInitMeta = SPAuthInitMeta()
            _err = error.errorDescription
        }
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    return AuthScreen().environmentObject(api)
}
