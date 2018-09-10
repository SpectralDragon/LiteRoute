
Pod::Spec.new do |s|
  s.name         = "LightRoute"
  s.version      = "2.1.19"
  s.summary      = "LightRoute is easy transition between view controllers and support many popylar arhitectures"
  s.description  = <<-DESC
                   LightRoute is easy transition between view controllers and support many popylar arhitectures. This framework very flow for settings your transition and have userfriendly API.
                   DESC
  s.homepage     = "https://github.com/SpectralDragon/LightRoute"
  s.documentation_url = "https://github.com/SpectralDragon/LightRoute"
  s.license      = "MIT"
  s.author       = { "Vladislav Prusakov" => "hipsterknights@gmail.com" }
  s.source       = { :git => "https://github.com/SpectralDragon/LightRoute.git", :tag => "#{s.version}", :submodules => false }

  s.ios.deployment_target = "8.0"

  s.source_files = "Sources/*.swift", "Sources/TransitionNodes/*.swift", "Sources/Protocols/*.swift"
end
