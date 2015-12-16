import Foundation

func runOpenPanel(allowedFileTypes: String,
    prompt: String) -> NSURL? {
        let op = NSOpenPanel()
        op.prompt = prompt
        op.allowsMultipleSelection = false
        // op.canChooseDirectories = true  // default
        op.resolvesAliases = true
        op.allowedFileTypes = [allowedFileTypes]
        let home = NSHomeDirectory()
        let d = home.stringByAppendingString("/Desktop/")
        op.directoryURL = NSURL(string: d)
        op.runModal()
        return op.URL
}

public func runSavePanel(allowedFileTypes: String,
    prompt: String) -> NSURL? {
        let sp = NSSavePanel()
        sp.prompt = prompt
        // op.canChooseDirectories = true  // default
        sp.allowedFileTypes = [allowedFileTypes]
        let home = NSHomeDirectory()
        let d = home.stringByAppendingString("/Desktop/")
        sp.directoryURL = NSURL(string: d)
        sp.runModal()
        return sp.URL
}
