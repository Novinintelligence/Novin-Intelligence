# NovinIntelligence iOS SDK 🛡️

**Enterprise-grade on-device AI security intelligence engine for iOS applications.**

Transform your app into an intelligent security system with real-time threat detection, powered by neural networks and advanced reasoning algorithms. Zero server calls, maximum privacy.

## 🚀 Quick Start

### 1. Add to Your Project

**Using Swift Package Manager (Recommended):**
```
File → Add Packages... → Enter: https://github.com/your-org/NovinIntelligenceSDK
```

**Manual Integration:**
- Download `NovinIntelligenceSDK` folder
- Copy to your project
- Add to your app target

### 2. Initialize SDK

```swift
import NovinIntelligence

@main
class AppDelegate: UIApplicationDelegate {
    func application(_ app: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Task {
            do {
                try await NovinIntelligence.shared.initialize()
                print("✅ Security SDK ready!")
            } catch {
                print("❌ SDK failed: \(error)")
            }
        }
        return true
    }
}
```

### 3. Assess Security Events

```swift
class SecurityManager {
    func handleMotion(confidence: Double) async {
        do {
            let assessment = try await NovinIntelligence.shared.assessMotion(confidence: confidence)

            switch assessment.threatAssessment.level {
            case .critical:
                triggerAlarm()
            case .elevated:
                sendNotification()
            case .normal:
                logEvent()
            }
        } catch {
            print("Assessment failed: \(error)")
        }
    }

    func handleFaceDetection(confidence: Double, isKnown: Bool) async {
        do {
            let assessment = try await NovinIntelligence.shared.assessFaceDetection(
                confidence: confidence,
                isKnown: isKnown
            )
            print("Face threat level: \(assessment.threatAssessment.level.rawValue)")
        } catch {
            print("Face assessment failed: \(error)")
        }
    }
}
```

## 📋 Requirements

- iOS 14.0+
- Swift 5.7+
- Xcode 14.0+

## 🔐 Security Features

- **Zero Source Code Exposure**: Pure Swift implementation
- **AI-Powered Analysis**: Neural network threat detection
- **Crime Intelligence**: Location-based risk assessment
- **Offline Operation**: No internet required
- **Production Ready**: Thread-safe, error handling

## 📊 API Reference

### NovinIntelligence.shared

#### Methods
- `initialize() async throws` - Initialize SDK
- `assess(requestJson: String) async throws -> SecurityAssessment` - Full assessment
- `assessMotion(confidence: Double) async throws -> SecurityAssessment` - Quick motion assessment
- `assessFaceDetection(confidence: Double, isKnown: Bool) async throws -> SecurityAssessment` - Quick face assessment

#### Properties
- `isReady: Bool` - SDK ready status
- `version: String` - SDK version

### SecurityAssessment

```swift
struct SecurityAssessment {
    let requestId: String
    let timestamp: Date
    let threatAssessment: ThreatAssessment
    let context: AssessmentContext
    let processingTimeMs: Double
}
```

### ThreatLevel

```swift
enum ThreatLevel: String, Codable {
    case normal    // Low risk
    case elevated  // Medium risk
    case critical  // High risk - immediate action required
}
```

## 🧪 Testing

```swift
// Test initialization
Task {
    try await NovinIntelligence.shared.initialize()
    assert(NovinIntelligence.shared.isReady)
}

// Test motion assessment
Task {
    let assessment = try await NovinIntelligence.shared.assessMotion(confidence: 0.9)
    print("Threat: \(assessment.threatAssessment.level)")
    print("Confidence: \(assessment.threatAssessment.confidence)")
}
```

## 📞 Support

- **Documentation**: Full API docs available
- **Integration Issues**: Check troubleshooting section
- **Licensing**: Contact sales@novinintelligence.com
- **Security**: Report issues to security@novinintelligence.com

---

*NovinIntelligence - AI-Powered Security for iOS* 🔒
