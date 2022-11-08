//
// 🦠 Corona-Warn-App
//

import Foundation
import CommonCrypto

extension Data {

    var sha256: Data {
        // via https://www.agnosticdev.com/content/how-use-commoncrypto-apis-swift-5

        // Creates an array of unsigned 8 bit integers that contains 32 zeros
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        // CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
        // Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
        _ = self.withUnsafeBytes {
            CC_SHA256($0.baseAddress, UInt32(self.count), &digest)
        }

        return Data(digest)
    }

    var fingerprint: String {
        sha256().base64EncodedString()
    }

    var keyIdentifier: String {
        sha256().subdata(in: 0..<8).base64EncodedString()
    }
}
