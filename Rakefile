require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Load stuff in IRB."
task :console do
  exec "irb -Ilib -rwmbind"
end

task :default => :spec

