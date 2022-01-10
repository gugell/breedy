# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def tools 
  pod 'SwiftLint'
end

def common_pods
  pod 'Kingfisher'
  pod 'Moya'
  pod 'CombineExt'
end

def ui 
  pod 'VanillaConstraints'
  pod 'MBProgressHUD', '1.2.0'
  pod 'Reusable'
end

target 'Breedy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  tools
  common_pods
  ui

  target 'BreedyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BreedyUITests' do
    # Pods for testing
  end
end
