$:.unshift File.expand_path('../lib', __FILE__)
require 'vagrant-aws-route53/version'

Gem::Specification.new do |s|
  s.name          = 'vagrant-aws-route53'
  s.version       = VagrantPlugins::AwsRoute53::VERSION
  s.platform      = Gem::Platform::RUBY
  s.license       = 'MIT'
  s.authors       = ['Colin Ogilvie', 'Naohiro Oogatta']
  s.email         = ['colin.ogilvie@madbid.com', 'oogatta@gmail.com']
  s.homepage      = 'https://github.com/Marcandi-Ltd/vagrant-aws-route53'
  s.summary       = 'Assigns IPs of Vagrant AWS instances to route 53.'
  s.description   = 'A Vagrant plugin assigns the IP of the instance which vagrant-aws provider created to a specific Route 53 record set.'
  s.require_path  = 'lib'
  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)

  s.add_runtime_dependency 'aws-sdk-v1'
end
