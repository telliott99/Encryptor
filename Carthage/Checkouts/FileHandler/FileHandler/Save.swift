import Foundation

let s1 = "Save Data To File:"

public func saveDataFileHandler(input: [UInt8], prompt: String = s1) -> Bool {
    let url = runSavePanel("bin", prompt: prompt)
    if url == nil { return false }
    
    let data = NSData(bytes: input,
        length: input.count)
    data.writeToURL(url!, atomically: true)
    
    return true
}

let s2 = "Save Decoded Text:"

public func saveTextFileHandler(input: String, prompt: String = s2) -> Bool {
    
    let url = runSavePanel("txt",
        prompt: prompt)
    if url == nil { return false }
    
    do {
        try input.writeToURL(
            url!,
            atomically: true,
            encoding: NSUTF8StringEncoding)
    }
    catch {
        return false
    }
    return true
}

