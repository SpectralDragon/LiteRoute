
Pod::Spec.new do |s|
  s.name         = "LightRoute"
  s.version      = "1.0.1"
  s.summary      = "LightRoute is easy transition between VIPER modules and not only. Written in Swift 3"
  s.description  = <<-DESC
                   LightRoute is easy transition between VIPER modules and not only. Written in Swift 3.
                   DESC
  s.homepage     = "https://github.com/SpectralDragon/LightRoute"
  s.documentation_url = "https://github.com/SpectralDragon/LightRoute"
  s.license      = "MIT"
  s.author       = { "Vladislav Prusakov" => "hipsterknights@gmail.com" }
  s.source       = { :git => "https://github.com/SpectralDragon/LightRoute.git", :tag => "#{s.version}", :submodules => false }

  s.ios.deployment_target = "8.0"

  s.source_files = "LightRoute/*.swift"
end
