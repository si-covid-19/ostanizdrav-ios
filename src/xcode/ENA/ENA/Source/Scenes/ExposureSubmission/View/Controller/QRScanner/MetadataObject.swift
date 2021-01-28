//
// 🦠 Corona-Warn-App
//

import Foundation

protocol MetadataObject: NSObjectProtocol {


}

protocol MetadataMachineReadableCodeObject: MetadataObject {

	var stringValue: String? { get }

}

