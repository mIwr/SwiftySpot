//
//  TestConstants.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

@testable import SwiftySpot

import Foundation

class TestConstants {
    
    static let device = SPDevice(os: "Android", osVer: "6.0.1", osVerNum: 23, cpuAbi: "32", manufacturer: "Samsung", model: "GT-I9500", deviceId: "e4615d56333747b9")
    
    static let clTokenContext = "AAB5nARw0grHJXTHGbtYcoK3bdZCIrsoXtZ2V1+4EUxUxN8VuRilSJLTWt7sFyPw2KlBe6Lcgg5ir/bhMCfmRgKBBXFdOSMMxjfElCmgx77cGWtTHjDOKFk0R+WeNKq6+4Zp4Yb8OfeAgKm4NRBZspPtMq8ff69q33bSzeuuWXAfFni7wHEaBvG4K1dNcTHGTizIvCmqPtKHn/Ro160LwXfy7hBkVDMugJDTApY1hTn2rJ4UEYqWX+6iYueyj9JTZ1BWObLttXMKRNdfG67orfn+JXq/XiWRxV9la91NBe9Fz0veFico/HO5IO0IcA=="
    static let clTokenHashcashPrefix = "0FA5978342C731C21B57CC4816848E64"
    static let clTokenHashcashLength: Int32 = 20
    static let clTokenHashcashAnswer = "95601890AFDACA69000000000002C360"//~200k iterations
    
    static let hardClTokenContext = "    AACkMDeKCKCvWc1sy2RX6la0/T8+EP6HVadNiRym8Uk16d7ql+NGc5pk6RdfVp+x4HUyAlgD3j6IPOi8vG7A+9+eF4xu1XUj7gh6uL6BzMNIuGgZ/mC3ZUZEWZPZ98oVlG1P0KsT9kkxBXvd4vy6nnw4msk1chZe81o4aSE0GYDLuIVC72wevM/ZP6lo9imO5vpKKYCdVSdQ7RuG4t74xKx1Zjm6sWoGToH58QiP0pBHMiSnTCkrUD9F38fzgVFjTWzBHGQdi/bkUYKDMEQWA/Gy5tV19hTD23Wu1UFIUAkWjyvIknvs3IKYSI0Dhg=="
    static let hardClTokenHashcashPrefix = "985D6CD6AADB14FACAC7AB0DDA72310F"
    static let hardClTokenHashcashLength: Int32 = 20
    static let hardClTokenHashcashAnswer = "95601890AFF0D4D0000000000018CDC7"//~1700k iterations

    static let authContextHex = "0300906a9a2085c6ab3e76ac1fd79b9a4e940643af4130f1ede085872a0f6ef3fc52225f1133fb0a0e223231f101674fa9a2522b8e3f7d09c2cfa41c46066b64318e6da04839d5c474e73cdba20c4e69857547ec533da3a3c938a962c531ae2afea33c7848ff3639c415c638b72f8ff9169c5bb418c7b9623ff0de303d8b25da631cd06d6a480e0a5904989b1a1c58ef78781f4d84402d0eee79e57ed2234104092e0c35bfc450b401b39e939d4d26030646072ac51acb8c0a813d6ed0b0abbbdc0fd74c2b32c254e4bfb67bb7e79a1c72d21c312c82f30798766bd4ed9d4936e8bd40ac866fcce84e8dbedf20f4485dff5975"
    static let authHashcashPrefixHex = "623669da405c9ff89d41ef4a4fcfa75b"
    static let authHashcashLength: Int32 = 10
    static let authHashcashAnswerHex = "0ba7e0812e948d18000000000000008d"
    
    static let playlistId = "37i9dQZEVXblV8enQMNFl5"
    static let artistId = "4MkrCf9RDnPGcKJJaIen7I"
    static let albumId = "7qTEgfVxRaGRPPwnIeWRRM"
    static let trackId = "1fGmf22HKepZQDSAUeHNEL"
    
    static let realBase62GID = "0XqDOKSvx2HrqsB5snefHl"
    static let realGID: Array<UInt8> = [0x1f, 0x7e, 0xa6, 0xe5, 0xba, 0x13, 0x43, 0x4f, 0x9c, 0xbc, 0x44, 0xee, 0xec, 0xf6, 0x35, 0xfb]
    
    fileprivate init() {}
    
    static let dummyApiProfileInfo: [String: Any] = [
        "display_name" : "Display name",
        "external_urls" : [
          "spotify": "https://open.spotify.com/user/usernameId"
        ],
        "href" : "https://api.spotify.com/v1/users/usernameId",
        "id" : "usernameId",
        "images" : [],
        "type" : "user",
        "uri" : "spotify:user:usernameId",
        "followers" : [
          "href": nil,
          "total" : 0
        ],
        "country" : "DE",
        "product" : "free",
        "explicit_content" : [
          "filter_enabled": false,
          "filter_locked": false
        ],
        "email" : "dummy@dummy.de",
        "birthdate" : "1970-01-01",
        "policies" : [
          "opt_in_trial_premium_only_market" : false
        ]
    ]
    
    static let dummyApiValidateInfo: [String: Any] = [
        "status": 120,
        "country": "DE",
        "dmca-radio": false,
        "shuffle-restricted": false,
        "can_accept_licenses_in_one_step": true,
        "requires_marketing_opt_in": false,
        "requires_marketing_opt_in_text": false,
        "minimum_age": 13,
        "country_group": "NA",
        "specific_licenses": false,
        "pretick_eula": true,
        "show_collect_personal_info": false,
        "use_all_genders": true,
        "use_other_gender": false,
        "use_prefer_not_to_say_gender": false,
        "show_non_required_fields_as_optional": false,
        "date_endianness": 2,
        "is_country_launched": true,
        "push-notifications": false,
    ]
    //{"status":120,"country":"DE","dmca-radio":false,"shuffle-restricted":false,"can_accept_licenses_in_one_step":true,"requires_marketing_opt_in":false,"requires_marketing_opt_in_text":false,"minimum_age":13,"country_group":"NA","specific_licenses":false,"pretick_eula":true,"show_collect_personal_info":false,"use_all_genders":true,"use_other_gender":false,"use_prefer_not_to_say_gender":false,"show_non_required_fields_as_optional":false,"date_endianness":2,"is_country_launched":true,"push-notifications":false}
}
