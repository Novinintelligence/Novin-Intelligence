import Foundation

/// Threat level enumeration
public enum ThreatLevel: String, CaseIterable, Codable {
    case critical = "critical"
    case elevated = "elevated"
    case standard = "standard"
    case ignore = "ignore"
    
    public var description: String {
        return rawValue
    }
}

/// Security assessment result from AI engine
public struct SecurityAssessment: Codable {
    public let threatLevel: ThreatLevel
    public let confidence: Double
    public let processingTimeMs: Double
    public let reasoning: String
    public let requestId: String?
    public let timestamp: String?
    
    public init(threatLevel: ThreatLevel, confidence: Double, processingTimeMs: Double, reasoning: String, requestId: String? = nil, timestamp: String? = nil) {
        self.threatLevel = threatLevel
        self.confidence = confidence
        self.processingTimeMs = processingTimeMs
        self.reasoning = reasoning
        self.requestId = requestId
        self.timestamp = timestamp
    }
}

/// NovinIntelligence SDK errors
public enum NovinIntelligenceError: Error, LocalizedError {
    case notInitialized
    case processingFailed(String)
    case invalidInput(String)
    case pythonRuntimeError(String)
    case bridgeError(String)
    
    public var errorDescription: String? {
        switch self {
        case .notInitialized:
            return "NovinIntelligence SDK not initialized. Call initialize() first."
        case .processingFailed(let message):
            return "Processing failed: \(message)"
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .pythonRuntimeError(let message):
            return "Python runtime error: \(message)"
        case .bridgeError(let message):
            return "Bridge error: \(message)"
        }
    }
}
