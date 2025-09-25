#!/bin/bash
# NovinIntelligence SDK Setup Script
# Automatically installs all dependencies and verifies the AI engine

set -e

echo "🛡️  NovinIntelligence SDK Setup"
echo "=================================="

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    echo "Please install Python 3.7+ and try again"
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Install Python dependencies
echo "📦 Installing Python dependencies..."

# Try pip install with user flag first, fallback to system-wide
if python3 -m pip install --user -r Sources/NovinIntelligence/Resources/requirements.txt; then
    echo "✅ Dependencies installed (user scope)"
elif python3 -m pip install --break-system-packages -r Sources/NovinIntelligence/Resources/requirements.txt; then
    echo "✅ Dependencies installed (system scope)"
else
    echo "❌ Failed to install dependencies"
    echo "Please install manually: pip3 install numpy scipy cryptography psutil"
    exit 1
fi

# Run dependency installer for verification
echo "🔧 Running dependency verification..."
if python3 Sources/NovinIntelligence/Resources/install_dependencies.py; then
    echo "✅ Dependencies verified"
else
    echo "⚠️  Dependency verification had issues, but may still work"
fi

# Test the AI engine
echo "🧠 Testing AI engine..."
if python3 -c "
import sys
sys.path.insert(0, 'Sources/NovinIntelligence/Resources/python/lib')
from novin_intelligence import get_embedded_system_instance
print('✅ AI engine import successful')
ai = get_embedded_system_instance()
print('✅ AI engine initialization successful')
print('🎉 NovinIntelligence SDK is ready!')
"; then
    echo "✅ AI engine test passed"
else
    echo "❌ AI engine test failed"
    exit 1
fi

echo ""
echo "🎉 NovinIntelligence SDK Setup Complete!"
echo ""
echo "📱 Integration Instructions:"
echo "1. Add this SDK to your Xcode project"
echo "2. Import NovinIntelligence in your Swift code"
echo "3. Call NovinIntelligence.shared.initialize() in your app"
echo "4. Use assess() methods for security events"
echo ""
echo "🔗 See INTEGRATION_GUIDE.md for detailed instructions"
echo ""
echo "✨ Your app now has enterprise-grade AI security!"
