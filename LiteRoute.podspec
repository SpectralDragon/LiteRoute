
Pod::Spec.new do |s|
  s.name         = "LiteRoute"
  s.version      = "2.1.21"
  s.summary      = "LiteRoute is easy transition between view controllers and support many popylar arhitectures"
  s.description  = <<-DESC
                  LiteRoute is easy transition between view controllers and support many popylar arhitectures. This framework very flow for settings your transition and have userfriendly API.
                   DESC
  s.homepage     = "https://github.com/SpectralDragon/LiteRoute"
  s.documentation_url = "https://github.com/SpectralDragon/LiteRoute"
  s.license      = "MIT"
  s.author       = { "Vladislav Prusakov" => "hipsterknights@gmail.com" }
  s.source       = { :git => "https://github.com/SpectralDragon/LiteRoute.git", :tag => "#{s.version}", :submodules => false }

  s.ios.deployment_target = "10.0"

  s.source_files = "Sources/*.swift", "Sources/TransitionNodes/*.swift", "Sources/Protocols/*.swift"
end
