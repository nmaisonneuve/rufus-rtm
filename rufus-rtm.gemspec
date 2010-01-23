
Gem::Specification.new do |s|

  s.name = 'rufus-rtm'
  s.version = '0.1.2'
  s.authors = [ 'Nicolas Maisonneuve' ]
  s.email = 'n.maisonneuve@gmail.com'
  s.homepage = 'http://rufus.rubyforge.org/rufus-rtm/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Fork from Rufus RTM gem '

  s.require_path = 'lib'
  s.test_file = 'test/test.rb'
  s.has_rdoc = true
  #s.extra_rdoc_files = %w{ README.txt CHANGELOG.txt CREDITS.txt LICENSE.txt }
  s.extra_rdoc_files = %w{ README.txt CHANGELOG.txt LICENSE.txt }
  s.rubyforge_project = 'rufus'

  #s.files = Dir['lib/**/*.rb'] + Dir['*.txt'] - [ 'lib/tokyotyrant.rb' ]
  s.files = Dir['lib/**/*.rb'] + Dir['*.txt']
end

