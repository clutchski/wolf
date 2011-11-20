
require "sprockets"
require "uglifier"


SOURCE_DIR = 'src'
BUILD_DIR = 'build'
EXAMPLE_DIR = 'examples'
TEST_DIR = 'tests'


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
    output_dir = File.dirname(output_file)
    mkdir_p output_dir
  
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
    sprocketize('wolf.coffee', "#{BUILD_DIR}/wolf.js", [SOURCE_DIR])
    notify("compiled source")
end

desc "Clean build artifacts."
task :clean do
    rm_rf BUILD_DIR
    notify("Clean!")
end

#
# Distribution tasks.
#

desc "Create a new distribution."
task :dist => [:build] do
  sh("cp #{BUILD_DIR}/wolf.js .")
  source = IO.read("wolf.js")
  uglified = Uglifier.compile(source)
  File.open("wolf.min.js", "w") do |f|
    f.write(uglified)
  end
  notify("Distro!")
end

#
# Testing tasks
#

desc "Build the test source."
task "test:build" do
  sprocketize('test_suite.coffee', "#{BUILD_DIR}/wolf_tests.js", [TEST_DIR])
  notify("Built tests!")
end

desc "Run tests in a browser."
task :test => ["test:build"] do
  open("#{TEST_DIR}/tests.html")
end

task :default => :test

#
# Documentation tasks.
#

desc "Build the README file."
task "readme" do
  mkdir_p BUILD_DIR
  sh("markdown README.md > #{BUILD_DIR}/readme.html")
end

task "readme:open" => ["readme"] do
  open("#{BUILD_DIR}/readme.html")
end

#
# Example tasks.
#

task "examples:build" do
  Dir.glob("#{EXAMPLE_DIR}/*.coffee") do |f|
    fname = File.basename(f)
    noext = fname.chomp(File.extname(fname))
    sprocketize(fname, "#{BUILD_DIR}/#{noext}.js", [EXAMPLE_DIR])
  end
  notify("Built examples!")
end

desc "Run the example programs."
task "examples" => [:build, "examples:build"] do
    Dir.glob("#{EXAMPLE_DIR}/*.html").each do |example|
        open(example)
    end
end
