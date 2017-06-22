
Pod::Spec.new do |s|

  s.name         = 'SCCycleScrollViewKit'
  s.version      = '0.1.2'
  s.summary      = 'A fast, lightweight carousel figure.'
  s.description  = 'A fast, lightweight carousel figure, which is based on UICollectionView.'
  s.homepage     = 'https://github.com/tsc000'
  s.license      = 'MIT'
  s.author             = { 'tsc000' => '787753577@qq.com' }
  s.platform     = 'ios'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/tsc000/SCCycleScrollView.git', :tag => s.version }
  s.source_files  = 'SCCycleScrollView/SCCycleScrollView/Source/*.swift'
  s.framework  = 'UIKit'
  s.requires_arc = true
  s.dependency "Kingfisher"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end