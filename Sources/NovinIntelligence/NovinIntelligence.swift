import Foundation

/// Main NovinIntelligence SDK class
@available(iOS 15.0, macOS 12.0, *)
public final class NovinIntelligence: @unchecked Sendable {
    
    /// Shared singleton instance
    public static let shared = NovinIntelligence()
    
    private var isInitialized = false
    private let pythonBridge = PythonBridge.shared
    private let processingQueue = DispatchQueue(label: "com.novinintelligence.processing", qos: .userInitiated)
    
    private init() {}
    
    // MARK: - Initialization
    
    /// Initialize the NovinIntelligence SDK
    public func initialize(brandConfig: String? = nil) async throws {
        guard !isInitialized else { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            processingQueue.async {
                do {
                    try self.pythonBridge.initialize()
                    self.isInitialized = true
                    print("✅ NovinIntelligence SDK initialized successfully")
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: NovinIntelligenceError.processingFailed("Initialization failed: \(error)"))
                }
            }
        }
    }
    
    // MARK: - Main API
    
    /// Process security event and return threat assessment
    public func assess(requestJson: String) async throws -> SecurityAssessment {
        guard isInitialized else {
            throw NovinIntelligenceError.notInitialized
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            processingQueue.async {
                let result = self.pythonBridge.processRequest(requestJson)
                
                switch result {
                case .success(let responseJson):
                    do {
                        let assessment = try self.parseAssessment(from: responseJson)
                        continuation.resume(returning: assessment)
                    } catch {
                        continuation.resume(throwing: NovinIntelligenceError.processingFailed("Failed to parse response: \(error)"))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// Feed any security event to the AI engine
    public func feedSecurityEvent(_ event: Any) async {
        guard isInitialized else {
            print("⚠️ NovinIntelligence not initialized")
            return
        }
        
        if let jsonString = event as? String {
            _ = try? await assess(requestJson: jsonString)
        } else if let dictionary = event as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: dictionary),
                  let jsonString = String(data: jsonData, encoding: .utf8) {
            _ = try? await assess(requestJson: jsonString)
        }
    }
    
    /// Set system mode for threat assessment context
    public func setSystemMode(_ mode: String) {
        print("🏠 System mode set to: \(mode)")
    }
    
    // MARK: - Private Helpers
    
    private func parseAssessment(from jsonString: String) throws -> SecurityAssessment {
        guard let data = jsonString.data(using: .utf8),
              let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NovinIntelligenceError.processingFailed("Invalid JSON response")
        }
        
        guard let threatAssessment = json["threatAssessment"] as? [String: Any],
              let levelString = threatAssessment["level"] as? String,
              let threatLevel = ThreatLevel(rawValue: levelString),
              let confidence = threatAssessment["confidence"] as? Double else {
            throw NovinIntelligenceError.processingFailed("Invalid threat assessment format")
        }
        
        let processingTimeMs = json["processingTimeMs"] as? Double ?? 0.0
        let reasoning = (json["reasoning"] as? [String: Any])?["primaryFactors"] as? [String]
        let reasoningString = reasoning?.joined(separator: ", ") ?? "AI assessment completed"
        let requestId = json["requestId"] as? String
        let timestamp = json["timestamp"] as? String
        
        return SecurityAssessment(
            threatLevel: threatLevel,
            confidence: confidence,
            processingTimeMs: processingTimeMs,
            reasoning: reasoningString,
            requestId: requestId,
            timestamp: timestamp
        )
    }
}

// MARK: - Convenience Extensions

@available(iOS 15.0, macOS 12.0, *)
extension NovinIntelligence {
    
    /// Quick motion assessment
    public func assessMotion(confidence: Double, location: (lat: Double, lon: Double)? = nil) async throws -> SecurityAssessment {
        let locationJson = location.map { "{\"lat\": \($0.lat), \"lon\": \($0.lon)}" } ?? "null"
        
        let timestamp = ISO8601DateFormatter().string(from: Date())

        let requestJson = """
        {
            "systemMode": "home",
            "location": \(locationJson),
            "deviceInfo": {"battery": 85},
            "events": [{
                "type": "motion",
                "confidence": \(confidence),
                "timestamp": "\(timestamp)",
                "metadata": {"deviceId": "convenience_motion"}
            }]
        }
        """
        
        return try await assess(requestJson: requestJson)
    }
    
    /// Quick face detection assessment
    public func assessFaceDetection(confidence: Double, isKnown: Bool = false, location: (lat: Double, lon: Double)? = nil) async throws -> SecurityAssessment {
        let locationJson = location.map { "{\"lat\": \($0.lat), \"lon\": \($0.lon)}" } ?? "null"
        
        let timestamp = ISO8601DateFormatter().string(from: Date())

        let requestJson = """
        {
            "systemMode": "away",
            "location": \(locationJson),
            "deviceInfo": {"battery": 90},
            "events": [{
                "type": "face",
                "confidence": \(confidence),
                "timestamp": "\(timestamp)",
                "metadata": {"is_known": "\(isKnown)"}
            }]
        }
        """
        
        return try await assess(requestJson: requestJson)
    }
}
