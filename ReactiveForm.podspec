Pod::Spec.new do |s|
  s.name = 'ReactiveForm'
  s.version = '0.2'
  s.platform = :ios
  s.ios.deployment_target = '5.0'
  s.homepage = "https://github.com/denis-mikhaylov/ReactiveForm"
  s.summary = "ReactiveForm is an Objective-C framework for composing of complex input forms based on ReactiveCocoa."
  s.author   = {
    'Denis Mikhaylov' => 'd.mikhaylov@qiwi.ru' 
  }
  # s.source = {
    # :git => 'https://github.com/denis-mikhaylov/ReactiveForm.git'
  # }
  s.source_files = 'ReactiveFormFramework/ReactiveForm/**/*.{h,m}'
  s.resources = ['**/*.{xcdatamodel,xcdatamodeld}'] 
  s.requires_arc = true
  s.dependency "ReactiveCocoa", "~> 2.0"
  s.prefix_header_contents = <<-EOS
#ifdef __OBJC__ 
#import "RFDefines.h" 
#endif
EOS
end
