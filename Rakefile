require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Load stuff in IRB."
task :console do
  exec "irb -Ilib -rwmbind"
end

desc "Run autotest."
task :autotest do
  exec "autotest -s rspec2"
end

task :default => :spec

