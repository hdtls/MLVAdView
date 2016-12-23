Pod::Spec.new do |s|

  s.name             = "MLVAdView"
  s.version          = "1.0.0"
  s.summary          = "MLVAdView help you create infinite scroll view to display a gallery contents"
  s.homepage         = "https://github.com/melvyndev/MLVAdView"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "melvyndev" => "melvyndev@icloud.com" }
  s.social_media_url = "http://twitter.com/melvyndev"
  s.platform         = :ios, "8.0"
  s.source           = { :git => "https://github.com/melvyndev/MLVAdView.git", :tag => "1.0.0" }
  s.source_files     = "Source/*.{h,m}"
  s.requires_arc     = true

end
