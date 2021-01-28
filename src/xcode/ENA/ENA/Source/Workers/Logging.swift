import Foundation
import os.log

extension OSLog {

	private static var subsystem = Bundle.main.unwrappedBundleIdentifier

    /// API interactions
    static let api = OSLog(subsystem: subsystem, category: "api")
    /// UI
    static let ui = OSLog(subsystem: subsystem, category: "ui")
    /// Local data & caches
    static let localData = OSLog(subsystem: subsystem, category: "localdata")
	/// Risk Detection
	static let riskDetection = OSLog(subsystem: subsystem, category: "riskdetection")
	/// App Config
	static let appConfig = OSLog(subsystem: subsystem, category: "appconfig")
	/// Contact Diary
	static let contactdiary = OSLog(subsystem: subsystem, category: "contactdiary")
	/// Background - Stuff that happens in the Background.
	static let background = OSLog(subsystem: subsystem, category: "background")

}

enum Log {

    static func debug(_ message: String, log: OSLog = .default) {
        Self.log(message: message, type: .debug, log: log, error: nil)
    }

    static func info(_ message: String, log: OSLog = .default) {
        Self.log(message: message, type: .info, log: log, error: nil)
    }

    static func warning(_ message: String, log: OSLog = .default) {
        Self.log(message: message, type: .default, log: log, error: nil)
    }

    static func error(_ message: String, log: OSLog = .default, error: Error? = nil) {
        Self.log(message: message, type: .error, log: log, error: error)
    }

	private static func log(message: String, type: OSLogType, log: OSLog, error: Error?) {
		#if !RELEASE

		os_log("%{private}@", log: log, type: type, message)

		// Save logs to File. This is used for viewing and exporting logs from debug menu.

		let fileLogger = FileLogger()
		fileLogger.log(message, logType: type)

		// Crashlytics
		// ...

		// Sentry
		// ...

		#endif
	}
}

// Usage:
// Log.debug("foo")
// Log.info("something broke", log: .api)
// Log.error("my hovercraft is full of eels", log: .ui)

#if !RELEASE

extension OSLogType {

	var title: String {
		switch self {
		case .error:
			return "Error"
		case .debug:
			return "Debug"
		case .info:
			return "Info"
		case .default:
			return "Warning"
		default:
			return "Other"
		}
	}

	var icon: String {
		switch self {
		case .error:
			return "❌"
		case .debug:
			return "🛠"
		case .info:
			return "ℹ️"
		case .default:
			return "⚠️"
		default:
			return ""
		}
	}
}

struct FileLogger {

	private let encoding: String.Encoding = .utf8
	private let logFileBaseURL: URL = {
		let fileManager = FileManager.default
		return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Logs")
	}()
	private let logDateFormatter = ISO8601DateFormatter()

	func makeWriteFileHandle(with logType: OSLogType) -> FileHandle? {
		let fileManager = FileManager.default
		let logFileURL = logFileBaseURL.appendingPathComponent("\(logType.title).txt")

		if !fileManager.fileExists(atPath: logFileURL.path) {
			try? fileManager.createDirectory(at: logFileBaseURL, withIntermediateDirectories: true)
			fileManager.createFile(atPath: logFileURL.path, contents: nil)
		}

		guard let fileHandle = try? FileHandle(forWritingTo: logFileURL) else {
			return nil
		}

		return fileHandle
	}

	func makeReadFileHandle(with logType: OSLogType) -> FileHandle? {
		let logFileURL = logFileBaseURL.appendingPathComponent("\(logType.title).txt")

		guard let fileHandle = try? FileHandle(forReadingFrom: logFileURL) else {
			return nil
		}

		return fileHandle
	}

	func log(_ logMessage: String, logType: OSLogType) {
		let prefixedLogMessage = "\(logType.icon) \(logDateFormatter.string(from: Date()))\n\(logMessage)\n\n"

		guard let fileHandle = makeWriteFileHandle(with: logType),
			  let logMessageData = prefixedLogMessage.data(using: encoding) else {
			return
		}

		fileHandle.seekToEndOfFile()
		fileHandle.write(logMessageData)
		fileHandle.closeFile()
	}

	func read(logType: OSLogType) -> String {
		guard let fileHandle = makeReadFileHandle(with: logType),
			  let logString = String(data: fileHandle.readDataToEndOfFile(), encoding: encoding) else {
			return ""
		}
		return logString
	}
	
	func deleteLogs() {
		try? FileManager.default.removeItem(at: logFileBaseURL)
	}
}

#endif
