## fattr.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "fattr"
  spec.description = 'fattr.rb is a "fatter attr" for ruby'  
  spec.version = "2.1.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "fattr"

  spec.files = ["a.rb", "fattr.gemspec", "lib", "lib/fattr.rb", "Rakefile", "README", "README.erb", "samples", "samples/a.rb", "samples/b.rb", "samples/c.rb", "samples/d.rb", "samples/e.rb", "samples/f.rb", "samples/g.rb", "samples/h.rb", "test", "test/fattr.rb"]
  spec.executables = []
  
  
  spec.require_path = "lib"
  

  spec.has_rdoc = true
  spec.test_files = "test/fattr.rb"
  #spec.add_dependency 'lib', '>= version'
  #spec.add_dependency 'fattr'

  spec.extensions.push(*[])

  spec.rubyforge_project = "codeforpeople"
  spec.author = "Ara T. Howard"
  spec.email = "ara.t.howard@gmail.com"
  spec.homepage = "http://github.com/ahoward/fattr/tree/master"
end
