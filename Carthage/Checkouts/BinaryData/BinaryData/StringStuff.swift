import Foundation

// useful String extensions for dealing with binary data

public extension String {
    
    /*
    basic sanity check, allow spaces
    is it consistent with binary data, optionally, with spaces
    */

    public func isValidByteString(spaces sp: Bool = false) -> Bool {
        var validChars = "0123456789abcdef".characters
        
        if sp {
            validChars = "0123456789abcdef ".characters
        }
        for c in self.characters {
            if !validChars.contains(c) {
                return false
            }
        }
        return true
    }
    
    /* 
    split a String into [String] of chunk size n
    allow last chunk to have any size <= n
    */
    
    public func divideIntoChunks(size n: Int) -> [String] {
        let cL = self.characters.map { String($0) }
        var ret: [String] = []
        var current = ""
        for (i,c) in cL.enumerate() {
            if (i != 0) && (i % n) == 0 {
                ret.append(current)
                current = ""
            }
            current += c
        }
        ret.append(current)
        return ret
    }
    
    /*
    splitOnStringCharacter (as String)
    often "\n"
    */
    
    public func splitOnStringCharacter(s: String) -> [String] {
        let c = Character(s)
        let a = self.characters.split { $0 == c }
        return a.map { String($0) }
    }
    
    /*
    iterate over characters
    the results are not Strings which joinWithSeparator requires,
    so do the conversion for each one with map
    */

    public func stripCharactersInList(cL: CharacterView) -> String {
        var a = [Character]()
        for c in self.characters {
            if cL.contains(c) {
                continue
            }
            a.append(c)
        }
        return a.map{String($0)}.joinWithSeparator("")
    }
    
    /* e.g. "ff" -> 255 */
    
    public func singleHexByteStringToInt(h: String) -> UInt8 {
        let sL = h.characters.map { String($0) }
        assert (sL.count == 2, "not 2 character byte")
        
        func f(s: String) -> Int {
            let D = ["a":10,"b":11,"c":12,
                "d":13,"e":14,"f":15]
            if let v = D[s] { return v }
            return Int(s)!
        }
        
        let ret = f(sL.last!) + 16 * f(sL.first!)
        return UInt8(ret)
    }
    
    
    public func hexByteStringToIntArray() -> [UInt8] {
        let cL = " ".characters
        let s = self.stripCharactersInList(cL)
        let sL = s.divideIntoChunks(size: 2)
        return sL.map { singleHexByteStringToInt($0) }
    }
}

// end of String extension

public typealias ByteString = String

public extension ByteString {
    
    /* e.g. put spaces every 2 characters */
    /* works with characters, not UTF8, so only for ByteString */
    
    public func insertSeparator(sep: String, every n: Int) -> ByteString {
        
        let ret = self.divideIntoChunks(size: n)
        return ret.joinWithSeparator(sep)
    }
}

