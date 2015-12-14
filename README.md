This is a demonstration project that uses the CommonCrypto library available on OS X.  A description of the original version is available on my blog:

* [writeup](http://telliott99.blogspot.com/2015/12/commoncrypto3.html)
* background [here](http://telliott99.blogspot.com/2015/12/commoncrypto.html) and [here](http://telliott99.blogspot.com/2015/12/commoncrypto2.html)

This version differs from what was described in being an OS X Framework.  Most of the classes and functions have been marked public and can be imported into another application.

To do this, build the project, then find the product and copy it into an appropriate directory (I use ``~/Library/Frameworks``).  Then just do ``import Encryptor`` in your Swift Cocoa application.  For this to work, you must tell Xcode about the linked framework (described [here](http://telliott99.blogspot.com/2015/12/building-and-using-framework-in-swift.html)).

Here is an example:

```swift
import Encryptor

func test() {
    let pw = "my passphrase"
    let key = Key(pw)
    key.stretch()
    let e = Encryptor(key)
    
    Swift.print(e)
    
    let msgText = "This is just a bit too long"
    print("msgText: \(msgText)")
    
    let msgData = BinaryData(msgText.utf8.map { UInt8($0) })
    print("\(msgData)")
    
    let cipherData = e.encrypt(msgData)
    
    print("cipherData: \(cipherData)")
    print("")
    
    let decryptedData = e.decrypt(cipherData)
    print("decryptedData: \(decryptedData)")
    
    let sa = decryptedData.data.map {
        Character(UnicodeScalar(UInt32($0))) }
    print(String(sa))
}
```

Output:

```
pw: my passphrase
salt: bf5db5b3b7b0
key:
pw:   my passphrase
data: bf30735360054c95e74d043bc6431192c86d4b21
salt: bf5db5b3b7b0
iv:
d04baeb8609f3588a94849841abdefb6
msgText: This is just a bit too long
54686973206973206a75737420612062697420746f6f206c6f6e67
encryptMany
encrypt round: 1
encryptOneChunk
msgLen: 16
msg:
54686973206973206a75737420612062
keyLen: 16
iv:
d04baeb8609f3588a94849841abdefb6
status: 0
result:
bf13c4338e52f350053de0eeb0caf889

encrypt round: 2
encryptOneChunk
msgLen: 16
msg:
697420746f6f206c6f6e670000000000
keyLen: 16
iv:
bf13c4338e52f350053de0eeb0caf889
status: 0
result:
d2771ae90aabd31494762e2a823ffbfb

cipherData: bf13c4338e52f350053de0eeb0caf889d2771ae90aabd31494762e2a823ffbfb

decryptMany
decryptOneChunk
data:
bf13c4338e52f350053de0eeb0caf889
keyLen: 16
iv:
d04baeb8609f3588a94849841abdefb6
status: 0
result:
54686973206973206a75737420612062

decryptOneChunk
data:
d2771ae90aabd31494762e2a823ffbfb
keyLen: 16
iv:
bf13c4338e52f350053de0eeb0caf889
status: 0
result:
697420746f6f206c6f6e670000000000

decryptedData: 54686973206973206a75737420612062697420746f6f206c6f6e670000000000
This is just a bit too long
```

To do:
I trimmed the null bytes off the end of the text version of the decrypted data by hand.