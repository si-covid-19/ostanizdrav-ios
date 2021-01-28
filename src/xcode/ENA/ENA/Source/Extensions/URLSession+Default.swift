//
// 🦠 Corona-Warn-App
//

import Foundation

extension URLSession {
	class func coronaWarnSession() -> URLSession {
		#if DISABLE_CERTIFICATE_PINNING
		/// Disable certificate pinning while app is running on:
		/// Community, Debug, TestFlight, UITesting modes
		let coronaWarnURLSessionDelegate: CoronaWarnURLSessionDelegate? = nil
		#else
		let coronaWarnURLSessionDelegate = CoronaWarnURLSessionDelegate(
			localPublicKey: "H2Am9Nz7BiC8PR4YKrNH0hlDHOM72EjPsfzWVba85Y4="
		)
		#endif
		return URLSession(
			configuration: .coronaWarnSessionConfiguration(),
			delegate: coronaWarnURLSessionDelegate,
			delegateQueue: .main
		)
		
	}
}
