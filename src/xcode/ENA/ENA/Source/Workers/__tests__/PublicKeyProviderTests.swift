//
// 🦠 Corona-Warn-App
//

import XCTest
#if canImport(CryptoKit)
import CryptoKit
#endif
@testable import ENA


final class PublicKeyProviderTests: CWATestCase {

	func testThatKeysHaveNotBeenAlteredAccidentally() throws {
		let environments = Environments()

		XCTAssertEqual(
			environments.environment(.production).validationKeyString,
			"c7DEstcUIRcyk35OYDJ95/hTg3UVhsaDXKT0zK7NhHPXoyzipEnOp3GyNXDVpaPi3cAfQmxeuFMZAIX2+6A5Xg=="
		)
	}
	
	// There was a bug in our code that converted the string rep. of the key to plain unicode instead of base64 encoded data.
	func testDefaultPublicKeyFromString() throws {
		guard #available(iOS 13.0, *) else {
		   throw XCTSkip("Unsupported iOS version")
		}

		let pk: String = "c7DEstcUIRcyk35OYDJ95/hTg3UVhsaDXKT0zK7NhHPXoyzipEnOp3GyNXDVpaPi3cAfQmxeuFMZAIX2+6A5Xg=="
		let data = try XCTUnwrap(Data(base64Encoded: pk))

		// the fallback in `DefaultPublicKeyFromString(pk)` - the default CryptoKit implementation is our reference
		let publicKey = try PublicKey(with: pk)
		// we have a valid assumption that CryptoKit is somewhat working…
		let referenceKey = try P256.Signing.PublicKey(rawRepresentation: data)

		XCTAssertEqual(publicKey.rawRepresentation, referenceKey.rawRepresentation)
	}
	
}
