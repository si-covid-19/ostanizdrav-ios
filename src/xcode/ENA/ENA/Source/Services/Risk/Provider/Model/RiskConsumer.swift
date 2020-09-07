//
// Corona-Warn-App
//
// SAP SE and all other contributors
// copyright owners license this file to you under the Apache
// License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import Foundation

final class RiskConsumer: NSObject {
	// MARK: Creating a Consumer
	init(targetQueue: DispatchQueue = .main) {
		self.targetQueue = targetQueue
	}

	// MARK: Properties
	/// The queue `didCalculateRisk` will be called on. Defaults to `.main`.
	let targetQueue: DispatchQueue

	/// Called when the risk level changed
	var didCalculateRisk: ((Risk) -> Void) = { _ in }

	/// Called when loading status changed
	var didChangeLoadingStatus: ((_ isLoading: Bool) -> Void)?
}
