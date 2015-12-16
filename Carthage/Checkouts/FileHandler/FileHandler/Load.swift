import Cocoa

public func loadDataFileHandler() -> [UInt8]? {
    let url = runOpenPanel("bin", prompt: "Open Data File:")
    if url == nil {
        return nil
    }
    let data = NSData(contentsOfURL:url!)
    if nil == data {
        return nil
    }
    
    let n = data!.length
    var a = [UInt8](count: n, repeatedValue: 0)
    data!.getBytes(&a, length: n)
    return a
}

public func loadTextFileHandler() -> String? {
    let url = runOpenPanel("txt", prompt: "Open Text File:")
    if url == nil {
        return nil
    }
    var s: String = ""
    do {
        s = try String(
            contentsOfURL:url!,
            encoding: NSUTF8StringEncoding)
    }
    catch {
        return nil
    }
    return s
}
