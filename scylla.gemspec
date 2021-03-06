# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scylla}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Druse"]
  s.date = %q{2010-09-13}
  s.default_executable = %q{scylla}
  s.description = %q{
      Scylla was a horrible monster with six grisly bear heads. Now it will help us kill Cucumber tests with ease.
    }
  s.email = %q{jon@jondruse.com}
  s.executables = ["scylla"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "bin/scylla",
     "example/config/scylla.yml",
     "lib/scylla.rb",
     "lib/scylla/assets/images/airport-arrivalsicon.png",
     "lib/scylla/assets/images/airport-board-background-bottom.png",
     "lib/scylla/assets/images/airport-board-background-top.png",
     "lib/scylla/assets/images/airport-display-background-left.png",
     "lib/scylla/assets/images/airport-display-background-right.png",
     "lib/scylla/assets/images/airport-display-person.png",
     "lib/scylla/assets/images/airport-display-strikethrough.png",
     "lib/scylla/assets/images/bg.jpeg",
     "lib/scylla/assets/styles.css",
     "lib/scylla/generator.rb",
     "lib/scylla/main.rb",
     "lib/scylla/options.rb",
     "lib/scylla/runner.rb",
     "lib/scylla/spawner.rb",
     "lib/scylla/views/scylla.html.erb",
     "scylla.gemspec",
     "test/helper.rb",
     "test/test_scylla.rb"
  ]
  s.homepage = %q{http://github.com/jondruse/scylla}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Kill your Cucumber tests faster with Scylla}
  s.test_files = [
    "test/helper.rb",
     "test/test_scylla.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0.8.2"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0.8.2"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0.8.2"])
  end
end

