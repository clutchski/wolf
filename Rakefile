#
# Timber build script.
#


require "sprockets"


SOURCE_DIR = 'src'
BUILD_DIR = 'build'
EXAMPLE_DIR = 'examples'
TEST_DIR = 'tests'
TEST_HARNESS = "#{TEST_DIR}/tests.html"


#
# Common functions.
#

def macos?
    RUBY_PLATFORM.downcase.include? 'darwin'
end

# Open the given file with it's default program.
def open(file)
    cmd = macos? ? "open" : "gnome-open" # supports macos and gnome
    sh("#{cmd} #{file}")
end

# Compile with sprockets.
def sprocketize(input_file, output_file, include_paths=[])
    environment = Sprockets::Environment.new
    include_paths.each{|p| environment.append_path(p)}

    File.open(output_file, 'w') do |f|
        f.write(environment[input_file])
    end
end

# Print a notice message.
def notify(message)
  padding = 4
  line = '*' * (message.length + padding)
  puts line
  puts "* #{message.upcase} *"
  puts line
end


#
# Tasks
# 

desc "Compile the source."
task :build do
    mkdir_p BUILD_DIR
    sprocketize('timber.coffee', "#{BUILD_DIR}/timber.js", [SOURCE_DIR])
    notify("compiled source")
end

desc "Clean build artifacts."
task :clean do
    rm_rf BUILD_DIR
    notify("Clean!")
end

#
# Testing tasks
#

namespace "test" do

  desc "Build the test source."
  task :build do
    sprocketize('timber_tests.coffee', "#{BUILD_DIR}/timber_tests.js", [TEST_DIR])
  end

  task :browser => [:build] do
    open(TEST_HARNESS)
  end

  desc "Run tests in phantomjs."
  task :phantomjs => [:build] do
      qunit_html = File.expand_path(TEST_HARNESS)
      cmd = "phantomjs #{TEST_DIR}/tests-phantom.js file://#{qunit_html}"
      sh(cmd)
  end
end

desc "Run tests in a browser."
task :test => ["test:browser"]

task :default => :test

#
# Example tasks.
#

desc "Run the example programs."
task "examples" => :build do
    Dir.glob("#{EXAMPLE_DIR}/*.html").each do |example|
        open(example)
    end
end

task "examples:pong" do
  open("#{EXAMPLE_DIR}/pong.html")
end
