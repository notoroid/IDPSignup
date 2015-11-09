Pod::Spec.new do |s|

  s.name         = "IDPSignup"
  s.version      = "0.0.1"
  s.summary      = "IDPSignup はBaaSの1つであるParseを利用したサインアップ機能を提供するためのスクリプトとiOSミドルウェア一式です。"

  s.description  = <<-DESC
                   IDPSignup はBaaSの1つであるParseを利用したサインアップ機能を提供するためのスクリプトとiOSミドルウェア一式です。サポートしているmBaaSはParse,サーバーサイドはPHP、クライアントサイドはObjective-Cで構築されています。
                   DESC

  s.homepage     = "https://github.com/notoroid/IDPSignup"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "notoroid" => "noto@irimasu.com" }
  s.social_media_url   = "http://twitter.com/notoroid"

  s.platform     = :ios, "8.0"
  
  s.source       = { :git => "https://github.com/notoroid/IDPSignup.git", :tag => "v0.0.1" }
  
  s.source_files  = "Lib/**/*.{h,m}"
  s.public_header_files = "Lib/**/*.h"
  
  s.dependency 'AFNetworking'
  s.dependency 'Parse'

  s.requires_arc = true

end
