Pod::Spec.new do |s|
  s.name         = "TagLibObjC"
  s.version      = "1.0.3"
  s.summary      = "An Objective-C wrapper around TagLib (at least, that's the goal)."
  s.homepage     = "https://github.com/leshkoapps/TagLib-ObjC"
  s.license      = 'MIT'
  s.author       = { "Enea" => "https://github.com/eni9889" }
  s.source       = { :git => "https://github.com/leshkoapps/TagLib-ObjC.git", :tag => s.version.to_s, :submodules => true }
  s.ios.deployment_target = '7.0'
  s.source_files = '*.{h}', 'taglib-objc/*.{h,mm}', 'taglib-src/taglib/**/*.{h,cpp}'
  s.requires_arc = true
  s.framework = 'Foundation'
  s.library   = "stdc++"
end
