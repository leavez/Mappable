Pod::Spec.new do |s|
    s.name             = 'Mappable'
    s.version          = '1.2.1'
    s.summary          = 'JSON Object mapping, supporting `let` properties.'

    s.description      = <<-DESC
    A simple convenient JSON object mapping tool, supporting model with `let` properties.
    DESC

    s.homepage         = 'https://github.com/leavez/Mappable'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { "leavez" => 'gaojiji@gmail.com' }
    s.source           = { :git => 'https://github.com/leavez/Mappable.git', :tag => s.version.to_s }

    s.source_files = 'Sources/**/*.swift'
    s.swift_version = "4.0"
    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.10'

    # s.test_spec 'Tests' do |test_spec|
    #     test_spec.source_files = 'Tests/**/*.swift'
    # end  
end
