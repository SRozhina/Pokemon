target 'CataPoke' do
  use_frameworks!

  pod 'SwiftLint'
  pod 'SwiftGen'
  pod 'Sourcery'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
    config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
   end
  end
 end
