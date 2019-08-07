Pod::Spec.new do |s|
  s.name         = "TagLibObjC"
  s.version      = "1.0.0"
  s.summary      = "An Objective-C wrapper around TagLib (at least, that's the goal)."
  s.homepage     = "https://github.com/leshkoapps/TagLib-ObjC"
  s.license      = 'MIT'
  s.author       = { "Enea" => "https://github.com/eni9889" }
  s.source       = { :git => "https://github.com/leshkoapps/TagLib-ObjC.git", :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = '*.{h,cpp}', 'taglib-objc/*.{h,m}', 'taglib-src/taglib/*.{h,cpp}', 'taglib-src/taglib/**/.{h,cpp}', 'taglib-src/3rdparty/**/.{h,cpp}'
  s.requires_arc = true
  s.framework = 'Foundation'
  s.library   = "stdc++"
end
