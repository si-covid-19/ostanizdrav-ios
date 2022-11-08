//
// 🦠 Corona-Warn-App
//

import Foundation

extension URLSession {
	class func coronaWarnSession(
		configuration: URLSessionConfiguration,
		delegateQueue: OperationQueue? = nil,
		withPinning: Bool = true
	) -> URLSession {
		
		var coronaWarnURLSessionDelegate: CoronaWarnURLSessionDelegate?
		if withPinning {
			coronaWarnURLSessionDelegate = CoronaWarnURLSessionDelegate(
				publicKeyHash: Environments().currentEnvironment().pinningKeyHash
			)
		}
		
		return URLSession(
			configuration: configuration,
			delegate: coronaWarnURLSessionDelegate,
			delegateQueue: delegateQueue
		)
	}
}
