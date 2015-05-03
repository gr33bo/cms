desc 'Run all tests'
task :spec do
  system "jruby -S rspec"
end
