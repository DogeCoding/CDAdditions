Pod::Spec.new do |s|
  s.name         = "CDAdditions"
  s.version      = "0.1.0"
  s.summary      = "常用系统分类，宏。"

  s.description  = <<-DESC
  自用系统分类、宏等。
                   DESC

  s.homepage     = "https://github.com/DogeCoding/CDAdditions"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "codingdoge" => "codingdoge@outlook.com" }

  s.platform     = :ios

  s.ios.deployment_target = '10.0'

  s.source       = { :git => "https://github.com/DogeCoding/CDAdditions.git", :tag => s.version }

  s.vendored_frameworks = 'CDAdditions.framework'

  s.frameworks = "UIKit", "Foundation"

#  s.libraries = "sys", "objc"
end