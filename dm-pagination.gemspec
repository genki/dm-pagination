# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-pagination}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Genki Takiuchi"]
  s.date = %q{2009-07-25}
  s.description = %q{DataMapper plugin that provides pagination}
  s.email = %q{genki@s21g.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/dm-pagination", "lib/dm-pagination/merbtasks.rb", "lib/dm-pagination/paginatable.rb", "lib/dm-pagination/pagination_builder.rb", "lib/dm-pagination/paginator", "lib/dm-pagination/paginator/solo.rb", "lib/dm-pagination/paginator/trio.rb", "lib/dm-pagination/paginator.rb", "lib/dm-pagination.rb", "spec/dm-pagination_spec.rb", "spec/fixture", "spec/fixture/app", "spec/fixture/app/controllers", "spec/fixture/app/controllers/pagination_builder.rb", "spec/fixture/app/models", "spec/fixture/app/models/post.rb", "spec/fixture/app/views", "spec/fixture/app/views/layout", "spec/fixture/app/views/layout/application.html.erb", "spec/fixture/app/views/pagination_builder", "spec/fixture/app/views/pagination_builder/index.html.erb", "spec/fixture/app/views/pagination_builder/simple.html.erb", "spec/fixture/app/views/pagination_builder/variant.html.erb", "spec/fixture/config", "spec/fixture/config/router.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://blog.s21g.com/genki}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{asakusarb}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{DataMapper plugin that provides pagination}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.9.11"])
      s.add_runtime_dependency(%q<agnostic>, [">= 0.1.0"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.9.11"])
      s.add_dependency(%q<agnostic>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.9.11"])
    s.add_dependency(%q<agnostic>, [">= 0.1.0"])
  end
end
