# NovinIntelligence SDK - Brand Integration Guide

## 🚀 Automatic Setup (Recommended)

### Step 1: Download and Setup SDK

1. **Download NovinIntelligence SDK** to your project directory
2. **Run automatic setup:**
   ```bash
   cd NovinIntelligenceSDK
   ./setup_novin_sdk.sh
   ```
3. **Done!** All Python dependencies auto-installed and verified

### Step 2: Add to Your Xcode Project

**Option A: Swift Package Manager (Recommended)**
```
File → Add Packages... → Add Local...
Select: NovinIntelligenceSDK folder
```

**Option B: Manual Copy**
- Copy entire `NovinIntelligenceSDK` folder to your project
- Add to your app target
- Ensure Python resources are included in bundle

### Step 2: Initialize SDK

Add to your `AppDelegate.swift`:

```swift
import UIKit
import NovinIntelligence

@main
class AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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

### Step 3: Use SDK

```swift
class SecurityManager {
    func onMotionDetected(confidence: Double) async {
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
            print("Security assessment failed: \(error)")
        }
    }
}
```

## 🧪 Test Integration

Run the included tests:
```bash
swift test
```

## 📱 Example App

See `ExampleApp/` for a complete working example.

## 🔐 AI Security Features

### Enterprise-Grade AI Engine
- **Neural Network Models**: Cryptographically signed and verified
- **8-Layer Reasoning**: Multi-faceted threat analysis pipeline
- **Crime Intelligence**: Location-based risk assessment
- **Rule Engine**: Emergency overrides and false positive reduction
- **Real-time Processing**: < 150ms average response time

### Security & Privacy
- **On-Device Processing**: No data sent to servers
- **Auto-Dependencies**: Python libraries installed automatically
- **Model Verification**: Digital signatures prevent tampering
- **Production Ready**: Rate limiting, error handling, monitoring

### AI Analysis Pipeline
When your app sends security events, they go through:

1. **Input Validation** - Schema and rate limit checks
2. **Feature Engineering** - Convert to 16K+ dimensional vectors  
3. **Neural Network** - Signed model predictions
4. **Rule Engine** - Emergency detection and overrides
5. **Crime Context** - Location-based threat correlation
6. **8-Layer Reasoning** - Advanced multi-factor analysis
7. **Threat Assessment** - Final level and confidence score
8. **Explainable Results** - Detailed reasoning factors

### Supported Event Types
- Motion detection (accelerometer, PIR sensors)
- Face recognition (known/unknown faces)
- Sound analysis (glass break, unusual noise)
- Entry sensors (doors, windows)
- Environmental (smoke, fire detection)
- Vehicle detection
- Pet detection (false positive reduction)

## 📞 Support

- Check `README.md` for full documentation
- Run tests to verify integration
- Contact your NovinIntelligence representative for support

---
*Integration complete! Your app now has enterprise-grade AI security.* 🎉
