# NovinIntelligence SDK Distribution Guide

## 🚀 How Brands Get the SDK

### Method 1: Swift Package Manager (Recommended)

Brands add this directly in Xcode:

```
File → Add Package Dependencies...
Enter URL: https://github.com/YourOrg/NovinIntelligenceSDK.git
Dependency Rule: Up to Next Major Version
Starting Version: 1.0.0
```

### Method 2: Download ZIP

1. Download from the latest release asset, e.g. https://github.com/YourOrg/NovinIntelligenceSDK/releases/download/1.0.0/NovinIntelligenceSDK-1.0.0.zip
2. Extract to project directory
3. In Xcode: `File → Add Local Package → Select extracted folder`

### Method 3: Git Clone

```bash
cd YourProject/
git clone https://github.com/YourOrg/NovinIntelligenceSDK.git
```

Then in Xcode: `File → Add Local Package → Select cloned folder`

## 📱 Integration Checklist for Brands

- **Prerequisites confirmed**
  - Xcode 14.0+ with iOS 15 simulator/device profiles
  - App target linked against `NovinIntelligence`
  - Network permissions **not** required (AI runs locally)
- **One-time SDK initialization**
  - Call `try await NovinIntelligence.shared.initialize()` during app launch (e.g., in `AppDelegate` or `@main` actor)
  - Monitor initialization by catching `NovinIntelligenceError`
  - Normalize each security event to the documented JSON envelope
  - Feed events via `try await NovinIntelligence.shared.assess(requestJson:)`
  - Handle the returned `SecurityAssessment` (threat level, confidence, reasoning)
- **Diagnostics (optional)**
  - Log `assessment.requestId` for traceability
  - Capture average processing time (values consistently above 300 ms on device indicate resource pressure)

### Step 1: Download & Setup
```bash
# If using download/clone method:
cd NovinIntelligenceSDK/
git checkout tags/v1.0.0
./setup_novin_sdk.sh   # Run once to fetch redistributable wheels
```

- **SPM users**: resources and wheels ship as prebuilt artifacts; no script is required.
- **Resource embedding**: `Resources/python` is declared as a `copy` resource, so the interpreter and models land in your `.app` automatically.
- **App Store compliance**: the embedded Python runtime is ahead-of-time compiled and never downloads executable code.
- **Performance targets**: plan for `< 250 ms` per emergency event and `< 350 ms` for routine events on device.
- **Network use**: the only downloads occur during the setup script on developer machines; runtime traffic stays local.

### Step 2: Add to Xcode Project
- Open your iOS project in Xcode
- File → Add Package Dependencies
- Choose your method above
- Add `NovinIntelligence` to your app target

### Step 3: Import & Use
```swift
import NovinIntelligence

@main
struct BrandSecurityApp: App {
    @State private var assessment: SecurityAssessment?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Kick this off during launch or behind a splash/progress view
                    try? await NovinIntelligence.shared.initialize()
                    let eventJson = SampleEvents.motion
                    assessment = try? await NovinIntelligence.shared.assess(requestJson: eventJson)
                }
        }
    }
}
```

## 🎯 What Happens Behind the Scenes

When brands add the SDK to their project:

1. **Xcode downloads the package** → Gets all source files and resources
2. **Swift Package Manager processes** → Configures build settings and dependencies  
3. **Resources get embedded** → Python AI engine gets bundled into the app
4. **Dependencies auto-install** → First run installs numpy, scipy, etc.
5. **Ready to use** → Full AI security system available

### Where the Python runtime lives

- `Package.swift` declares `Resources/python` (including `Python.xcframework`, wheels, and the AI modules) with the `copy` resource rule, so Xcode automatically places them inside the `.app` bundle for both simulator and device builds.
- No manual copy phases are required; brands can confirm by inspecting `YourApp.app/Frameworks/PythonSupport`.
- The packaged Python runtime is all ahead-of-time compiled. It loads signed modules only and never JITs or downloads executable code, satisfying App Store guideline 2.5.2.

## 🌐 Platform Coverage & On-Device Isolation

- **Supported Apple targets**: iOS 15+, iPadOS 15+, visionOS 1.0+ (same Swift API). tvOS/watchOS support is planned; contact us for beta frameworks.
- **On-device execution**: Every app ships with its own embedded Python runtime. No event data leaves the device; there is no shared interpreter across users or devices.
- **Thread safety**: `NovinIntelligence.shared` is `@unchecked Sendable`; internal queues serialize bridge calls, so multiple Swift tasks can stream events safely.
- **Resource profile**: ~50 MB app size increase, ~120 ms average per-event processing, with memory stabilized after initialization.

## 📦 Package Contents

```
NovinIntelligenceSDK/
├── 📱 Sources/NovinIntelligence/           ← Swift interface
├── 🧠 Resources/python/                   ← AI engine (embedded in app)
├── 🔧 setup_novin_sdk.sh                  ← Dependency installer
├── 📋 README.md                           ← Documentation
└── 📦 Package.swift                       ← SPM configuration
```

## ✅ Requirements

- iOS 15.0+
- Xcode 14.0+
- Python 3.7+ (for AI engine)
- 50MB app size increase (for AI models)
- Initial setup (if using ZIP/clone) requires running `./setup_novin_sdk.sh` once on the developer’s Mac to fetch redistributable wheels. Swift Package Manager integrations ship with prebuilt artifacts, so no extra script is needed in that path.

## 🔍 Validation Before Shipping

1. **Run automated integration tests**
   ```bash
   xcodebuild \
     -scheme NovinIntelligence \
     -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
     test
   ```
   - Executes `IOSIntegrationTests.testProcessSingleEvent` to confirm initialization + threat processing succeed in a clean simulator.
2. **Feed sample events manually**
   ```swift
   let events = [SampleEvents.motion, SampleEvents.faceUnknown, SampleEvents.fire]
   for event in events {
       let assessment = try await NovinIntelligence.shared.assess(requestJson: event)
       assert(assessment.confidence > 0)
   }
   ```
3. **Verify runtime metrics**
   - Ensure `assessment.processingTimeMs < 250` for emergency scenarios and `< 350` for bulk feeds on physical devices. Simulator runs may be slower.
   - Capture logs for `requestId` to correlate device telemetry if needed.

## 🔒 Security Note

All AI models are cryptographically signed and verified on device. No runtime event data leaves the device. Any Python wheels downloaded by `setup_novin_sdk.sh` occur only at build time on the developer’s machine.
