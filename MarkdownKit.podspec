Pod::Spec.new do |s|
  s.name         = "MarkdownKit"
  s.version      = "0.1.0"
  s.summary      = "Simple Makrdown toolkit"
  s.homepage     = "https://github.com/safx/MarkdownKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "MATSUMOTO Yuji" => "safxdev@gmail.com" }
  s.source       = { :git => "https://github.com/safx/MarkdownKit.git", :tag => s.version }
  s.source_files = "Source/**/*.{m,h}", "External/hoedown/src/*.{c,h}"
  s.ios.deployment_target = "8.1"
  s.osx.deployment_target = "10.9"
  s.requires_arc = true
end
