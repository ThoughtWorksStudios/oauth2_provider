### gemspec: arrayfields-4.7.4

  Gem::Specification::new do |spec|
    spec.name = "arrayfields"
    spec.version = "4.7.4"
    spec.platform = Gem::Platform::RUBY
    spec.summary = "arrayfields"

    spec.files = ["arrayfields.gemspec", "gemspec.rb", "install.rb", "lib", "lib/arrayfields.rb", "README", "readme.rb", "sample", "sample/a.rb", "sample/b.rb", "sample/c.rb", "sample/d.rb", "sample/e.rb", "test", "test/arrayfields.rb", "test/memtest.rb"]
    spec.executables = []
    
    spec.require_path = "lib"

    spec.has_rdoc = true
    spec.test_files = "test/arrayfields.rb"
    #spec.add_dependency 'lib', '>= version'
    #spec.add_dependency 'fattr'

    spec.extensions.push(*[])

    spec.rubyforge_project = 'codeforpeople'
    spec.author = "Ara T. Howard"
    spec.email = "ara.t.howard@gmail.com"
    spec.homepage = "http://github.com/ahoward/arrayfields/tree/master"
  end

