//
//  ErrorType.swift
//
//  Created by Abdelrhman Eliwa.
//

enum ErrorType {
    // MARK: - Network
    case connection
    case unwrappedHttpClient
    case unwrappedHttpServer
    
    // MARK: - Decoder
    case mapping
    
    // MARK: - Local
    case logical
    case hardware
    case exception
    case permission
    case validation
    
    // MARK: - OTHER
    case unexpected
}

// MARK: - ErrorType + Message
extension ErrorType {
    var message: String {
        switch self {
        case .connection: return "Connection Reason"
        case .unwrappedHttpClient: return "Unwrapped HTTP Client Reason"
        case .unwrappedHttpServer: return "Unwrapped HTTP Server Reason"
        case .mapping: return "Mapping Reason"
        case .logical: return "Logical Reason"
        case .hardware: return "Hardware Reason"
        case .exception: return "Exception Reason"
        case .permission: return "Permission Reason"
        case .validation: return "Validation Reason"
        case .unexpected: return "Unexpected Reason"
        }
    }
}

// MARK: - ErrorType + Code
extension ErrorType {
    var code: Int {
        switch self {
        case .connection: return ErrorConstants.Code.connectionCode
        case .unwrappedHttpClient: return ErrorConstants.Code.unwrappedHttpClientCode
        case .unwrappedHttpServer: return ErrorConstants.Code.unwrappedHttpServerCode
        case .mapping: return ErrorConstants.Code.mappingCode
        case .logical: return ErrorConstants.Code.logicalCode
        case .hardware: return ErrorConstants.Code.hardwareCode
        case .exception: return ErrorConstants.Code.exceptionCode
        case .permission: return ErrorConstants.Code.permissionCode
        case .validation: return ErrorConstants.Code.validationCode
        case .unexpected: return ErrorConstants.Code.unexpectedCode
        }
    }
}
