Gem::Specification.new do |s|
  s.name        = 'gpgroup'
  s.version     = '0.0.0'
  s.date        = '2014-02-13'
  s.summary     = "Group management for GPG encrypted files"
  s.description = "Group management for GPG encrypted files "
  s.authors     = ["Scott Woods", "Justin Patterson"]
  s.email       = ["jrp22@psu.edu","team@westarete.com"]
  s.homepage    = 'https://github.com/psu-stewardship/gpgroup'
  s.license     = 'Apache 2.0'

  s.add_runtime_dependency 'thor', '~> 0.18'
  s.add_development_dependency 'rspec', '~> 2.14'

  s.files       = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md)
  s.executables = ['gpgroup']
end
