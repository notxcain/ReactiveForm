Pod::Spec.new do |s|
  s.name = 'ReactiveForm'
  s.version = '0.3'
  s.platform = :ios
  s.ios.deployment_target = '5.0'
  s.homepage = "https://github.com/ReactiveForm/ReactiveForm"
  s.summary = "ReactiveForm is an Objective-C framework for composing of complex input forms based on ReactiveCocoa."
  s.author   = {
    'Denis Mikhaylov' => 'd.mikhaylov@qiwi.ru' 
  }
  s.source_files = 'ReactiveFormFramework/ReactiveForm/**/*.{h,m}'
  s.requires_arc = true
  s.dependency "ReactiveCocoa", "~> 2.0"
end
