# Novin-Intelligence SDK Setup Instructions

## 🚀 One-Click Setup for Brand Apps

### Step 1: Clone the SDK
```bash
git clone https://github.com/Novinintelligence/Novin-Intelligence.git
```

### Step 2: Run Setup (One Time Only)
```bash
cd Novin-Intelligence
bash setup_novin_sdk.sh
```
This installs:
- ✅ NumPy, SciPy, Cryptography, PsUtil
- ✅ AI engine verification
- ✅ All dependencies ready

### Step 3: Add to Your Xcode Project
1. In Xcode: **File → Add Package Dependencies**
2. Add: `file:///path/to/Novin-Intelligence`
3. Select the package

### Step 4: Use in Your App
```swift
import NovinIntelligence

// Initialize once at app launch
try await NovinIntelligence.shared.initialize()

// Assess security events
let result = try await NovinIntelligence.shared.assess(requestJson: json)
```

### Step 5: Build & Run
```bash
xcodebuild -scheme "YourApp" build
```
**No manual dependency management needed!**

## 🎯 What This Gives Your Brands

- **Zero External Dependencies** - Everything embedded
- **One Download Experience** - Clone → Setup → Build
- **Enterprise Security** - AI-powered threat detection
- **Privacy-First** - All processing on-device

## ✅ Tested & Verified

- ✅ Python dependencies auto-install
- ✅ AI engine initializes correctly  
- ✅ Swift integration works
- ✅ Builds successfully in Xcode
- ✅ Runs in iOS Simulator & Device
