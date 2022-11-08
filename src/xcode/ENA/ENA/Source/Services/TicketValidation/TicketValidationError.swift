//
// 🦠 Corona-Warn-App
//

import Foundation
import ENASecurity

enum TicketValidationError: LocalizedError {
	case validationDecoratorDocument(ServiceIdentityValidationDecoratorError)
	case validationServiceDocument(ServiceIdentityRequestError)
	case keyPairGeneration(ECKeyPairGenerationError)
	case accessToken(TicketValidationAccessTokenProcessingError)
	case encryption(EncryptAndSignError)
	case resultToken(TicketValidationResultTokenProcessingError)
	case allowListError(AllowListError)
	case versionError(VersionError)
	case other

	// swiftlint:disable cyclomatic_complexity
	func errorDescription(serviceProvider: String) -> String? {
		let serviceProviderError = String(
			format: AppStrings.TicketValidation.Error.serviceProviderError,
			serviceProvider
		)

		switch self {
		case .validationDecoratorDocument(let error):
			switch error {
			case .VD_ID_EMPTY_X5C, .VD_ID_NO_ATS_SIGN_KEY, .VD_ID_NO_ATS_SVC_KEY, .VD_ID_NO_ATS, .VD_ID_NO_VS_SVC_KEY, .VD_ID_NO_VS:
				return "\(serviceProviderError) (\(error))"
			case .REST_SERVICE_ERROR(let serviceError):
				switch serviceError {
				case .receivedResourceError(.VD_ID_CLIENT_ERR), .receivedResourceError(.VD_ID_PARSE_ERR):
					return "\(serviceProviderError) (\(serviceError))"
				default:
					return "\(AppStrings.TicketValidation.Error.tryAgain) (\(serviceError))"
				}
			}
		case .validationServiceDocument(let error):
			switch error {
			case .VS_ID_EMPTY_X5C, .VS_ID_NO_ENC_KEY, .VS_ID_NO_SIGN_KEY:
				return "\(serviceProviderError) (\(error))"
			case .REST_SERVICE_ERROR(let serviceError):
				switch serviceError {
				case .receivedResourceError(.VS_ID_CERT_PIN_MISMATCH), .receivedResourceError(.VS_ID_CERT_PIN_HOST_MISMATCH), .receivedResourceError(.VS_ID_CLIENT_ERR), .receivedResourceError(.VS_ID_PARSE_ERR):
					return "\(serviceProviderError) (\(serviceError))"
				default:
					return "\(AppStrings.TicketValidation.Error.tryAgain) (\(serviceError))"
				}
			default:
				return "\(AppStrings.TicketValidation.Error.tryAgain) (\(error))"
			}
		case .keyPairGeneration(let error):
			return "\(AppStrings.TicketValidation.Error.tryAgain) (\(error))"
		case .accessToken(let error):
			switch error {
			case .ATR_AUD_INVALID, .ATR_JWT_VER_ALG_NOT_SUPPORTED, .ATR_JWT_VER_EMPTY_JWKS, .ATR_JWT_VER_NO_JWK_FOR_KID, .ATR_JWT_VER_NO_KID, .ATR_JWT_VER_SIG_INVALID, .ATR_PARSE_ERR, .ATR_TYPE_INVALID:
				return "\(serviceProviderError) (\(error))"
			case .REST_SERVICE_ERROR(let serviceError):
				switch serviceError {
				case .receivedResourceError(.ATR_CERT_PIN_MISMATCH), .receivedResourceError(.ATR_CERT_PIN_NO_JWK_FOR_KID), .receivedResourceError(.ATR_CLIENT_ERR), .receivedResourceError(.ATR_PARSE_ERR):
					return "\(serviceProviderError) (\(serviceError))"
				default:
					return "\(AppStrings.TicketValidation.Error.tryAgain) (\(serviceError))"
				}
			default:
				return "\(AppStrings.TicketValidation.Error.tryAgain) (\(error))"
			}
		case .encryption(let error):
			return "\(serviceProviderError) (\(error))"
		case .resultToken(let error):
			switch error {
			case .RTR_JWT_VER_ALG_NOT_SUPPORTED, .RTR_JWT_VER_EMPTY_JWKS, .RTR_JWT_VER_NO_JWK_FOR_KID, .RTR_JWT_VER_NO_KID, .RTR_JWT_VER_SIG_INVALID, .RTR_PARSE_ERR:
				return "\(serviceProviderError) (\(error))"
			case .REST_SERVICE_ERROR(let serviceError):
				switch serviceError {
				case .receivedResourceError(.RTR_CERT_PIN_MISMATCH), .receivedResourceError(.RTR_CERT_PIN_HOST_MISMATCH), .receivedResourceError(.RTR_CLIENT_ERR), .receivedResourceError(.RTR_PARSE_ERR):
					return "\(serviceProviderError) (\(serviceError))"
				default:
					return "\(AppStrings.TicketValidation.Error.tryAgain) (\(serviceError))"
				}
			default:
				return "\(AppStrings.TicketValidation.Error.tryAgain) (\(error))"
			}
		case .allowListError(let error):
			switch error {
			case .SP_ALLOWLIST_NO_MATCH:
				return "\(AppStrings.TicketValidation.Error.serviceProviderErrorNoMatch) (\(error))"
			case .REST_SERVICE_ERROR(let error):
				return "\(AppStrings.TicketValidation.Error.tryAgain) (\(error))"
			}
		case .versionError(let error):
			return "\(AppStrings.TicketValidation.Error.outdatedApp) (\(error))"
		default:
			return "\(AppStrings.TicketValidation.Error.tryAgain) (\(self))"
		}
	}
}
