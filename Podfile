target 'CataPoke' do
  use_frameworks!

  pod 'SwiftLint'
  pod 'SwiftGen'
  pod 'Swinject'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
   end
  end
 end