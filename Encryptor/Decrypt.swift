import Foundation
import CommonCrypto

extension Encryptor {
    
    func decryptOneChunk(input: BinaryData, iv: BinaryData = BinaryData())  -> BinaryData {
        
        eprint("decryptOneChunk")
        eprint("data:\n\(input)")
        
        let stdBufferSize = 16 // AES128BlockSize in bytes
        
        let cipherData = input.data
        
        let decryptedData = [UInt8](        // not really constant!
            count: stdBufferSize,
            repeatedValue: 0)
        
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(0)  // CBC
        
        // stretched self.key is 20 bytes, must truncate
        let key16Data = self.key.data[0..<stdBufferSize]
        
        // fix problem with "slice"
        let keyData = Array<UInt8>(key16Data)
        
        let keyLen = keyData.count
        eprint("keyLen: \(keyLen)")
        
        eprint("iv:\n\(iv)")
        
        var status: Int32 = 0
        var resultLen = 0
        
        status = CCCrypt(
            CCOperation(kCCDecrypt),
            algorithm,
            options,
            keyData,
            keyLen,
            iv.data,
            cipherData,
            stdBufferSize,
            UnsafeMutablePointer<Void>(decryptedData),
            stdBufferSize,
            &resultLen)
        
        eprint("status: \(status)")
        let result = BinaryData(decryptedData)
        eprint("result:\n\(result)\n")
        return result
    }
    
    func decryptMany(input: BinaryData, ivIn: BinaryData = BinaryData()) -> BinaryData {
        eprint("decryptMany")
        var i = 0
        var j = 0
        let n = 16
        var ret = BinaryData()
        var tmp = BinaryData()
        var currentIV = self.iv
        
        // however, if encryption and decryption are decoupled
        // this instance needs the correct iv
        
        if ivIn.count != 0 {
            currentIV = ivIn
        }
        
        while i < input.count {
            j = min(input.count, i + n)
            tmp = self.decryptOneChunk(
                input[i..<j],
                iv: currentIV)
            ret = ret + tmp
            
            // crucial change:
            // currentIV = tmp
            currentIV = input[i..<j]
            i = i + n
        }
        return ret
    }

}