//
//  SPError.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

///Represents general exceptions of API work
public enum SPError
{
  ///General-purpose error
  case general(errCode: Int, data: [String: Any])
  ///Request init related error
  case badRequest(errCode: Int, description: String)
  ///Error response http status code
  case invalidResponseStatusCode(errCode: Int, description: String)
  ///Caused error response payload data
  case badResponseData(errCode: Int, data: [String: Any])
  ///Refresh authorization errror
  case refreshAuthDataNotExists(usernameFound: Bool, storedCredFound: Bool)
  ///Defined file (audio codec) is restricted to play
  case playIntentRestricted(hexFileId: String)
  ///Audio file preview not found
  case audioPreviewNotFound
}

extension SPError: Error {
    ///General error code, if status code is unknown or can't be retrieved
    public static let GeneralErrCode: Int = -1
    
    public var errorDescription: String {
        switch(self) {
        case .general(let errCode, _):
            return "General error - " + String(errCode)
        case .badRequest(_, let description):
            return "Bad request: " + description
        case .invalidResponseStatusCode(let errCode, let description):
            return "Invalid response status code " + String(errCode) + "\n" + description
        case .badResponseData:
            return "Invalida response data"
        case .refreshAuthDataNotExists(let usernameFound, let storedCredFound):
            if (!usernameFound && !storedCredFound) {
                return "Not found username and stored credentials to refresh auth"
            }
            if (!usernameFound) {
                return "Not found username to refresh auth"
            }
            if (!storedCredFound) {
                return "Not found stored credentials to refresh auth"
            }
            return "Unsufficient data to refresh auth"
        case .playIntentRestricted(let hexFileId):
            return "Play intent for file ID " + hexFileId + " is restricted"
        case .audioPreviewNotFound:
            return "Not found audio preview for defined track"
        }
    }
}
