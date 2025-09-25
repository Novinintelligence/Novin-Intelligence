Pod::Spec.new do |spec|
  spec.name         = "NovinIntelligence"
  spec.version      = "1.0.0"
  spec.summary      = "Enterprise-grade on-device AI security intelligence engine for iOS"
  spec.description  = <<-DESC
    Transform your app into an intelligent security system with real-time threat detection, 
    powered by neural networks and advanced reasoning algorithms. Zero server calls, maximum privacy.
  DESC

  spec.homepage     = "https://github.com/NovinIntelligence/iOS-SDK"
  spec.license      = { :type => "Commercial", :file => "LICENSE" }
  spec.author       = { "NovinIntelligence" => "sdk@novinintelligence.com" }

  spec.ios.deployment_target = "15.0"
  spec.swift_version = "5.7"

  spec.source       = { :git => "https://github.com/NovinIntelligence/iOS-SDK.git", :tag => "#{spec.version}" }

  spec.source_files = "Sources/**/*.{swift,h,m}"
  spec.public_header_files = "Sources/NovinPythonBridge/include/**/*.h"

  # Include Python AI engine and models as resources
  spec.resources = [
    "Sources/NovinIntelligence/Resources/**/*"
  ]

  # Embed Python framework
  spec.vendored_frameworks = "Python.xcframework"

  # Compiler flags for Python integration
  spec.xcconfig = {
    'OTHER_LDFLAGS' => '-framework Python',
    'FRAMEWORK_SEARCH_PATHS' => '$(SRCROOT)/../Python.xcframework/**'
  }

  # Dependencies will be installed via setup script
  spec.script_phase = {
    :name => 'Install AI Dependencies',
    :script => 'if [ -f "${SRCROOT}/../setup_novin_sdk.sh" ]; then bash "${SRCROOT}/../setup_novin_sdk.sh"; fi',
    :execution_position => :before_compile
  }

  spec.prepare_command = <<-CMD
    echo "Setting up NovinIntelligence AI dependencies..."
    if [ -f "./setup_novin_sdk.sh" ]; then
      chmod +x ./setup_novin_sdk.sh
      ./setup_novin_sdk.sh
    fi
  CMD
end
