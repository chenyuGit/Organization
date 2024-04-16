#
# Be sure to run `pod lib lint ZJKApplyCompany.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZJKApplyCompany'
  s.version          = '0.1.0'
  s.summary          = '申请单位组件'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://devcloud.cn-east-3.huaweicloud.com/codehub/project/b1481406533a43ae97442ee612446bab/codehub/7396382/home?ref=master'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhongjunkeji' => 'zhongjunkeji.com' }
  s.source           = { :git => 'https://codehub.devcloud.cn-east-3.huaweicloud.com/jybiOSzjkjdlAPP_chenyu00001/ZJKApplyCompany.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version = '5.0'

  s.ios.deployment_target = '12.0'
  s.dependency 'SnapKit'
  s.dependency 'JYBProgressHUD'
  s.dependency 'AFNetworking'
  s.dependency 'ZJNetWork'
  s.dependency 'MJExtension'
  s.dependency 'ZJKKit'

  #s.source_files = 'ZJKApplyCompany/**/*'

  s.resource_bundles = {
     'imageSources' => ['ZJKApplyCompany/**/*.*']
  }
  s.subspec 'Model' do |ss|
      ss.source_files = "ZJKApplyCompany/Model/**/*"
  end

  s.subspec 'Net' do |ss|
      ss.source_files = "ZJKApplyCompany/Net/**/*"
  end
  
  s.subspec 'Tool' do |ss|
      ss.source_files = "ZJKApplyCompany/Tool/**/*"
  end
  
  s.subspec 'V' do |ss|
      ss.source_files = "ZJKApplyCompany/V/**/*"
  end
  
  s.subspec 'VC' do |ss|
      ss.source_files = "ZJKApplyCompany/VC/**/*"
  end
  
#  s.resource_bundles = {
#     'ZJKApplyCompany' => ['ZJKApplyCompany/Assets/*']
#  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
