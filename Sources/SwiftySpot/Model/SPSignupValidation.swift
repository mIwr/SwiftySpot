//
//  SignupValidation.swift
//  SwiftySpot
//
//  Created by developer on 10.11.2023.
//

import Foundation

///Represents spotify signup validation meta info
class SPSignupValidation: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case countryCode = "country"
        case dmcaRadio = "dmca-radio"
        case shuffleRestricted = "shuffle-restricted"
        case fastAcceptLicense = "can_accept_licenses_in_one_step"
        case requireMarketingOptIn = "requires_marketing_opt_in"
        case requireMarketingOptInText = "requires_marketing_opt_in_text"
        case minimumAge = "minimum_age"
        case countryGroup = "country_group"
        case specificLic = "specific_licenses"
        case pretickEULA = "pretick_eula"
        case showPersonalInfoCollectNotice = "show_collect_personal_info"
        case useAllGenders = "use_all_genders"
        case useOtherGender = "use_other_gender"
        case undefinedGenderAvailable = "use_prefer_not_to_say_gender"
        case nonRequiredFieldsAsOptional = "show_non_required_fields_as_optional"
        case dateEndianness = "date_endianness"
        case countryLaunched = "is_country_launched"
        case pushNotifications = "push-notifications"
    }
    
    ///Validation status code
    public let status: Int
    ///Country code
    public let countryCode: String
    public let dmcaRadio: Bool
    public let shuffleRestricted: Bool
    public let fastAcceptLicense: Bool
    public let requireMarketingOptIn: Bool
    public let requireMarketingOptInText: Bool
    ///Minimum age for service use
    public let minimumAge: Int
    ///Country group
    public let countryGroup: String
    public let specificLic: Bool
    public let pretickEULA: Bool
    public let showPersonalInfoCollectNotice: Bool
    public let useAllGenders: Bool
    public let useOtherGender: Bool
    public let undefinedGenderAvailable: Bool
    public let nonRequiredFieldsAsOptional: Bool
    public let dateEndianness: Int
    ///Spotify is available in country flag
    public let countryLaunched: Bool
    ///Available push notifications flag
    public let pushNotifications: Bool

    init(status: Int, countryCode: String, dmcaRadio: Bool, shuffleRestricted: Bool, fastAcceptLicense: Bool, requireMarketingOptIn: Bool, requireMarketingOptInText: Bool, minimumAge: Int, countryGroup: String, specificLic: Bool, pretickEULA: Bool, showPersonalInfoCollectNotice: Bool, useAllGenders: Bool, useOtherGender: Bool, undefinedGenderAvailable: Bool, nonRequiredFieldsAsOptional: Bool, dateEndianness: Int, countryLaunched: Bool, pushNotifications: Bool) {
        self.status = status
        self.countryCode = countryCode
        self.dmcaRadio = dmcaRadio
        self.shuffleRestricted = shuffleRestricted
        self.fastAcceptLicense = fastAcceptLicense
        self.requireMarketingOptIn = requireMarketingOptIn
        self.requireMarketingOptInText = requireMarketingOptInText
        self.minimumAge = minimumAge
        self.countryGroup = countryGroup
        self.specificLic = specificLic
        self.pretickEULA = pretickEULA
        self.showPersonalInfoCollectNotice = showPersonalInfoCollectNotice
        self.useAllGenders = useAllGenders
        self.useOtherGender = useOtherGender
        self.undefinedGenderAvailable = undefinedGenderAvailable
        self.nonRequiredFieldsAsOptional = nonRequiredFieldsAsOptional
        self.dateEndianness = dateEndianness
        self.countryLaunched = countryLaunched
        self.pushNotifications = pushNotifications
    }
}
