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
key:
pw:   my passphrase
data: f2de6d46394e7e5ade06cfd947b10b2a28b0c012
salt: 9cb34d9057a8
iv:
552b1c6dc6b88aa150d51b44f44cd366
msgText: This is just a bit too long
54686973206973206a75737420612062697420746f6f206c6f6e67
cipherData: 3d2d1846e203a94e7f54af54db6f6bd7525c59609be79b148fd0d164cd498e99

decryptedData: 54686973206973206a75737420612062697420746f6f206c6f6e670000000000
This is just a bit too long
```

To do:
I trimmed the null bytes off the end of the text version of the decrypted data by hand.