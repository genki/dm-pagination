require 'rubygems'
require 'rake/gempackagetask'

GEM_NAME = "dm-pagination"
GEM_VERSION = "0.4.0"
AUTHOR = "Genki Takiuchi"
EMAIL = "genki@s21g.com"
HOMEPAGE = "http://blog.s21g.com/genki"
SUMMARY = "DataMapper plugin that provides pagination"
RUBYFORGE_PROJECT = "asakusarb"

spec = Gem::Specification.new do |s|
  s.rubyforge_project = RUBYFORGE_PROJECT
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency('dm-core', '>= 0.9.11')
  s.add_dependency('agnostic', '>= 0.1.0')
  s.require_path = 'lib'
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
	pkg.need_tar = true
  pkg.gem_spec = spec
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Run spec"
task :spec do
  sh "spec spec --color"
end

desc 'Package and upload the release to rubyforge.'
task :release => :package do |t|
  require 'rubyforge'
	v = ENV["VERSION"] or abort "Must supply VERSION=x.y.z"
	abort "Versions don't match #{v} vs #{GEM_VERSION}" unless v == GEM_VERSION
	pkg = "pkg/#{GEM_NAME}-#{GEM_VERSION}"

	require 'rubyforge'
	rf = RubyForge.new.configure
	puts "Logging in"
	rf.login

	c = rf.userconfig
#	c["release_notes"] = description if description
#	c["release_changes"] = changes if changes
	c["preformatted"] = true

	files = [
		"#{pkg}.tgz",
		"#{pkg}.gem"
	].compact

	puts "Releasing #{GEM_NAME} v. #{GEM_VERSION}"
	rf.add_release RUBYFORGE_PROJECT, GEM_NAME, GEM_VERSION, *files
end

task :default => :spec
