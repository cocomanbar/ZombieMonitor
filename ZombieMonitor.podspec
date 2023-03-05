Pod::Spec.new do |s|
  s.name             = 'ZombieMonitor'
  s.version          = '1.0.0'
  s.summary          = 'Zombie Monitor'
  s.description      = 'In the development stage, discover zombie objects that may appear in the program as early as possible'
  s.homepage         = 'https://github.com/cocomanbar/ZombieMonitor'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cocomanbar' => '125322078@qq.com' }
  s.source           = { :git => 'https://github.com/cocomanbar/ZombieMonitor.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  
  non_arc_files = 'ZombieMonitor/Classes/Non_arc_files/*.{h,m}'
  
  s.subspec 'Non_arc_files' do |a|
      a.source_files = non_arc_files
      a.requires_arc = false
      a.dependency 'ZombieMonitor/Core'
  end
  
  s.subspec 'Core' do |a|
      a.source_files = 'ZombieMonitor/Classes/Core/*'
      a.requires_arc = true
  end
  
end
