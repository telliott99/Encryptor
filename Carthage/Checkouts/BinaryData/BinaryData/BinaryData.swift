import Foundation

public func +(lhs: BinaryData, rhs: BinaryData) -> BinaryData {
    return BinaryData(lhs.data + rhs.data)
}

public class BinaryData : CustomStringConvertible, Indexable {
    
    public var data: [UInt8] = []
    
    // we allow data to be empty
    public init(_ input: [UInt8] = []) {
        data = input
    }
    
    public convenience init(byteString b : ByteString) {
        // print("BinaryData.init(_: String): \(b)")
        // allow spaces
        assert (b.isValidByteString(spaces: true),
            "found some bad characters in input bytes \"\(b)\"")
        self.init(b.hexByteStringToIntArray())
    }
    
    public var description : String {
        get {
            let sa = data.map { intToHexByte($0) }
            // return sa.joinWithSeparator(" ")
            return sa.joinWithSeparator("")
        }
    }
    
    public var count : Int {
        get {
            return self.data.count
        }
    }
    
    public var endIndex: Int {
        get {
            return data.count
        }
    }
    
    public var startIndex: Int {
        get {
            return 0
        }
    }
    
    public subscript (position: Int) -> UInt8 {
        get {
            return data[position]
        }
    }

    public subscript (r: Range<Int>) -> BinaryData {
        get {
            var ret: [UInt8] = []
            for (i,v) in data.enumerate() {
                if r.contains(i) {
                    ret.append(v)
                }
            }
            return BinaryData(ret)
        }
    }
}

