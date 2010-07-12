# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chronic}
  s.version = "0.2.3"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Preston-Werner"]
  s.cert_chain = nil
  s.date = %q{2007-07-02}
  s.description = %q{Chronic is a natural language date/time parser written in pure Ruby. See below for the wide variety of formats Chronic will parse.}
  s.email = %q{tom@rubyisawesome.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/chronic.rb", "lib/chronic/chronic.rb", "lib/chronic/grabber.rb", "lib/chronic/handlers.rb", "lib/chronic/ordinal.rb", "lib/chronic/pointer.rb", "lib/chronic/repeater.rb", "lib/chronic/repeaters/repeater_day.rb", "lib/chronic/repeaters/repeater_day_name.rb", "lib/chronic/repeaters/repeater_day_portion.rb", "lib/chronic/repeaters/repeater_fortnight.rb", "lib/chronic/repeaters/repeater_hour.rb", "lib/chronic/repeaters/repeater_minute.rb", "lib/chronic/repeaters/repeater_month.rb", "lib/chronic/repeaters/repeater_month_name.rb", "lib/chronic/repeaters/repeater_season.rb", "lib/chronic/repeaters/repeater_season_name.rb", "lib/chronic/repeaters/repeater_second.rb", "lib/chronic/repeaters/repeater_time.rb", "lib/chronic/repeaters/repeater_week.rb", "lib/chronic/repeaters/repeater_weekend.rb", "lib/chronic/repeaters/repeater_year.rb", "lib/chronic/scalar.rb", "lib/chronic/separator.rb", "lib/chronic/time_zone.rb", "lib/numerizer/numerizer.rb", "test/suite.rb", "test/test_Chronic.rb", "test/test_Handler.rb", "test/test_Numerizer.rb", "test/test_RepeaterDayName.rb", "test/test_RepeaterFortnight.rb", "test/test_RepeaterHour.rb", "test/test_RepeaterMonth.rb", "test/test_RepeaterMonthName.rb", "test/test_RepeaterTime.rb", "test/test_RepeaterWeek.rb", "test/test_RepeaterWeekend.rb", "test/test_RepeaterYear.rb", "test/test_Span.rb", "test/test_Time.rb", "test/test_Token.rb", "test/test_parsing.rb"]
  s.homepage = %q{	http://chronic.rubyforge.org/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{chronic}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A natural language date parser}
  s.test_files = ["test/test_Chronic.rb", "test/test_Handler.rb", "test/test_Numerizer.rb", "test/test_parsing.rb", "test/test_RepeaterDayName.rb", "test/test_RepeaterFortnight.rb", "test/test_RepeaterHour.rb", "test/test_RepeaterMonth.rb", "test/test_RepeaterMonthName.rb", "test/test_RepeaterTime.rb", "test/test_RepeaterWeek.rb", "test/test_RepeaterWeekend.rb", "test/test_RepeaterYear.rb", "test/test_Span.rb", "test/test_Time.rb", "test/test_Token.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hoe>, [">= 1.2.1"])
    else
      s.add_dependency(%q<hoe>, [">= 1.2.1"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.2.1"])
  end
end
