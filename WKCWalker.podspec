Pod::Spec.new do |s|
s.name         = "WKCWalker"
s.version      = "1.1.4"
s.summary      = "The animation is loaded in a chained manner. The following functions are classified by MARK"
s.homepage     = "https://github.com/WKCLoveYang/WKCWalker.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCWalker.git", :tag => "1.1.4" }
s.source_files  = "WKCWalker/**/*.swift"
s.requires_arc = true
s.swift_version = "5.0"
end
