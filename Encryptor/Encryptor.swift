import Foundation

public class Encryptor: CustomStringConvertible {
    
    public var key: Key
    public var iv = randomBinaryData(16)
    
    public init(_ input: Key) {
        key = input
    }
    
    public var description : String {
        get {
            return "key:\n\(key)\niv:\n\(iv)"
        }
    }
    
    public func encrypt(input: BinaryData) -> BinaryData {
        return encryptMany(input)
    }
    
    public func decrypt(input: BinaryData) -> BinaryData {
        return decryptMany(input)
    }
}
