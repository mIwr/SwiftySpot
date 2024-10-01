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
    static let trackIdWithLyrics = "6QO7NLCdpQnsPDNyUI24kz"
    static let feedbackTrackId = "spotify:track:1fGmf22HKepZQDSAUeHNEL"
    static let feedbackContext = "spotify:playlist:37i9dQZF1E371G6gGxF85G"
    
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
    
    static let dummySeektableResult: [String: Any] = [
        "seektable_version": "1",
        "offset": 1230,
        "timescale": 44100,
        "segments": [[163156, 441344], [165499, 441344], [165199, 440320], [165486, 441344], [165388, 441344], [165252, 440320], [165482, 441344], [165322, 441344], [165073, 440320], [165536, 441344], [165392, 441344], [126523, 334449]],
        "encoder_delay_samples": 1024,
        "padding_samples": 399,
        "pssh": "AAAAU3Bzc2gAAAAA7e+LqXnWSs6jyCfc1R0h7QAAADMIARIQXsZdsnRvQ8pFjENjZV8bqBoHc3BvdGlmeSIUXsZdsnRvQ8pFjENjZV8bqM7ElBU=",
        "index_range": [1054, 1229]
    ]
    
    static let licChallengeHexStr =    "0801129711124b0a490a33080112105ec65db2746f43ca458c4363655f1ba81a0773706f7469667922145ec65db2746f43ca458c4363655f1ba8cec4941510011a1067b887bfa8a67e6e395fc84ab008639e18012090c3feb506301538a4efc3e30542b7100a0b73706f746966792e636f6d12104f2d27d961597a7cbd8a2a343468eb521a800e402e22e9c5ad8c8bff66566f44c970863560066bf234a3bd2bcaf0755321446f312cfeea6f65c79056f1a5bf38b203af3bf3652f06e9eb2ca9aab00906b7f0b3ad7205300172708f05738e41bea7c3f3fb246943208c710d56f34e29e8571817cbb9b9d7367ade262af13bcbdc91162f0eb8be6b91e0ef250c81ce65cabc4c62e1a4d4cb609621a00d3b752ef35cd5f7eadfbec5a43180fc1584f63b92ffff4abb7cda21c975f6e93512ca670ad0d493ee886772f838cd0bdba64bca9e9cb27468f6a2395189d7e8e34a7e46c2512333baa8f64e0ceb41fa19a9b6fb431386b254a498904ff6b9efaea648a996ab13895acf08519291fa5ed2a282facdec8d65fe2bbaa97310589f29b9cf531df96e74046b85773d71387de52521db83c1f7e2c644849e37a68b45a4a9a4659121f51752ab35ce7e3577e960188d00837020cd2af7ad2c89054a5a67c22dde1ca3200f2303e31027f509b2d81bfb612a29af8d93d64885720077dc64b2e09e5b9466ad11775e57f636edfe6c4a22401bacbeac6ff6c15b2a1fe583cc38e28138f9888b398ad32e9fbc9e822f75b186e0952b05b78e9d47e9f6147d802f9c11dddb7b8852c25a481440de467d8ce66402eb8223e081a416c33c0c0eb43d58306b6c0f03c0e637a17e1a678471c78e74042199005f36c76a8374b72c04395a9a30c6d8651c69d91a25c8eece435e6c3bdcaeec2660262d4b5bd9a6ba59a16c82d4d56cf13a70fbcdf335951c55f52f5a987b28a4b2849fd0ef810e9a8c8b7b2306f3ce1ddd3961465f1e4eb37688865386d442921abda0bfba0d01e5239f6eb0a68c93fe8e64158ae729089ecade0c2f30c99ccffef58dcbe9b2d5c81b85ae00283f04114bc736a13a88b859defa6af305e5bbc4426100c5b48609c43806ff796fdb0f139a79e42f9139fb2fe16c6a0e8bfe26b99fc8c8b4583fcad01b69d35108216daa078eaaff1abc25a2ebc1e0cdf62005bfc0bbdacaae9227f11cc56631ce9432e82d5823f1421d28d66bceb7e4e55e02f1e698d4afd1bf2a5411d7d5e331727a574ceee850e91b401f38ef763c96ef0524724b186a62b97f24bd017cb3d0b35a64898eadf8db22741f579eddff8b7135125f99ac45227fff4345a9d2d42b5137d33a8d4ee32f77e9d5aa505eb373957641b88d7ee5411d0ebff8e2cdcaf2fdfb328e6511aacfa82ed946ac869907594adcca30f66b96d323f2c909bba02db18719599d22a566379ee71a7ae9ebfa8c17cc4ea5c7d106f9928f66dffc5d86c3cafae2ebe3a8e0f42f7c8e71b12c198c48cf2c82bae4d71e8d5b0346763cbd5ebeb35f86a358dca0a1591b7c665c8b4d998fa469ce381e0ffc8265ec6f2a94f14de0fd51e8e9523597fa1557c0952d5f8cbb6e1ad3b5e42e06565ea065c694bc7307ecbb0f15b2f4069bd00daa9a644f1fa843935581a7f57ffb002e50ff3d483f2ca008395efe908b09ee5422c0537f1ac719f0c75af8152f63d2c4d0c3f6351b9c6822b1252e67f081f30a90e322afe05eff2b05f66bf675debcf0af0db11093d69a7586b529e0b229b6c3f3fd9e9bb16919a4c2a44a8b8c5981c2a1fa86816e1b2663b7a5efe0d6dc9423a02d001d9f9e28a271806f84e5f92100795a71cb6675d734cf71982538e82704455062b9f9dad3235c36b385bdcd634111425ff9e9fd596834f3f4fec28c154b0657dd492fc00d5db14c9c99ac42b20a08433d88f40f67b26c38f0344590fd23c3ff1a92a42fe794a8eb97a5dada68ff1f85ef6be6104f3c6b10bada206d1087b5a3ecb3bf5a12f54581378666760bd2997ec80beb7790bd79c8be6c6a7b4d6eea7aead22eefc2f16f6240f135a3e859e88a1677c15b17267d37d9a7b736139982dcec159f4018649a150bf4197a9774f6a9cd0e774a261bb49bd11f6a8d5a2e599226e72ee6a929dbf2b90b10671b3b159c75caa7e7ca4ef9379a1f37aef8e758647a750f4b4f1b854fc048551a3bfb869f606a92d2ee15fc2973e3bd3d1537d4592af36cc7df88de6ad6dd4430ad9252a6adbbbe3684b1ac21f7c840e9d2c096f4407edb7533ee6a6c3a7c7c512f1d7ec5998dacb49a09882ab46437af944dc758c126a90040c3e0ea2fe92ef146df990d29878ac346b57e2b939000d7aafcac4bd0a482fb3396e8daeed0b4c3b873028e8df7632f88d6794fac95bff32eaade722279a61d081027bd0e4297e16bb5999181e3c6cdf7f2d13f8ac0218310d9c98c46c436d18641fc2d2fce43fd8b8d88d894f4ae309325c29f57853a5bec5c4bde7d2173d93f26bc5fe2129ee411a9d2d686df09e67838b1480c751283e4302bc8f3acf3c6b452f3f769709c3319b7f62ca91a706b4b064d03ce89e2cbd3b6373309f813a1d32ddd30c9e8758da6fe402721f3ce8603c8d2c53934969199a2cb04f9182b16514cd0ced5dec3efbd5eca8cb55db47ae283190dbdeb413340aa94ac46f1eb3f0cba977a0ccd37665f33b57e103076fe87d92ae2ea717e9e0b0ff50e9ca1200622103c8796717ab6dff3990b675c5d381e4c2a80020a62e9618a711294d2d19156698466686ee4e677dae9a9a0d28fc82f7154f5b2ead1d9468d27d60b48cf63d3616974caef5eb22509e8c7f6aa2f085955e3d05bb8897d263913d9471f66ba84742a38e600ef2e885527c0f2d02e78bf2bbc93f8496dcb337fd119bfc91b724995b289d685e344bb3a6e5366648bd219341305723c7f2681ac8edc13eac953cc96c70e51f11536f50f27e97df72ada6c7f683ae6de9b0683f7eb8b00b35626ebed362eba4ee6bcfc2cbf7a47dc708b60ece07c4fdba9ed5c2307148260ae1f7f36d77127fd334e734d5774726fdb642c6407eb152f13c898f281be10e74ff70d2bef45fbadecf3eb124fd59743f987598f38be931a80025b860c7646b92ab4fb3a3bbf801ec2a7ae017132e3c03798c4d0cfe8458174fbb9e36b09356ea7055ae813e1deb8c970f8b22f049721d4a15d9eb55fec466929eef76027fdac64ee943bb9435c1d5472969a2dc1ea045219f13ecb8f2361c45a71beb160e6912c506e6d868dcc276e02f6b99f1d3388c7539df7b5843e04c0f9bc21d72bf9a75fef0868fdba684bcab50840f88075c9446f3fd41e8a3035a2af501f677980c6e518d0d0c774c7012ec84fb6248b038f48d77d94d0853ab8e746af1b23bdf59ccceec803187c11dd50ff7090ab933aa093899a006555b5d6af401d6375512ef449a9416a54bc58a758b73330a8a463f8ebf826ce75f98449de35"    
    
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
    
    static let dummySyncedLyricsInfo: [String: Any] = [
        "error":false,
        "syncType":"LINE_SYNCED",
        "lines": [
            ["startTimeMs":"900","words":"One, two, three, four","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"4030","words":"Ooh-ooh, ooh-ooh-ooh","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"10510","words":"Every time you come around, you know I can't say no","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"18010","words":"Every time the sun goes down, I let you take control","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"25680","words":"I can feel the paradise before my world implodes","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"32800","words":"And tonight had something wonderful","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"39250","words":"My bad habits lead to late nights endin' alone","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"43250","words":"Conversations with a stranger I barely know","syllables":[],"endTimeMs":"0"]
        ]
    ]
    
    static let dummyUnsyncedLyricsInfo: [String: Any] = [
        "error":false,
        "syncType":"UNSYNCED",
        "lines":[
            ["startTimeMs":"0","words":"Why are we fighting","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"What do we seek","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"In a heart that's been broken","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"Rebuilt by machines","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"Is there anyone there?","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"My signal is weak","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"I'm fighting my conscience in a dreamless sleep","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"Cuz i'm losing my patience","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"And i'm getting complacent","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"Shake my foundation to its core","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"You make me feel like i'm walking on water","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"And you make me question what i'm building these walls for","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"Was it your intention to give my spirit a home","syllables":[],"endTimeMs":"0"],
            ["startTimeMs":"0","words":"Before i let you light my bones on fire","syllables":[],"endTimeMs":"0"]
        ]
    ]
}
