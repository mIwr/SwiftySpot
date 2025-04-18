import Foundation
import Security

class SecureStorage {
    
    static let kSecClassValue = NSString(format: kSecClass)
    static let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
    static let kSecValueDataValue = NSString(format: kSecValueData)
    static let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
    static let kSecAttrServiceValue = NSString(format: kSecAttrService)
    static let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
    static let kSecReturnDataValue = NSString(format: kSecReturnData)
    static let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
    
    fileprivate init() {}

    class func save(key: String, data: Data) -> OSStatus {
        let query =
            [
                kSecClass as String       : kSecClassGenericPassword as String,
                kSecAttrAccount as String : key,
                kSecAttrService as String : Bundle.main.bundleIdentifier ?? Constants.PSEUDO_BUNDLE_NAME,
                kSecValueData as String   : data,
                kSecAttrAccessible as String : kSecAttrAccessibleAfterFirstUnlock
            ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }
    
    class func delete(key: String) -> OSStatus{
        let query =
        [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
        ] as [String : Any]
        
        return SecItemDelete(query as CFDictionary)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecAttrService as String : Bundle.main.bundleIdentifier ?? Constants.PSEUDO_BUNDLE_NAME,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
}

extension Data {

    init<T>(from value: T) {
        self = withUnsafePointer(to: value)
        {
            (pointer: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
    
    mutating func append<T>(value: T)
    {
        withUnsafePointer(to: value)
        {
            (pointer: UnsafePointer<T>) in
            append(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
