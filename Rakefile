#
# Timber build script.
#


require "sprockets"


SOURCE_DIR = 'src'
BUILD_DIR = 'build'
EXAMPLE_DIR = 'examples'

TEST_SOURCE_DIR = 'tests/src'
TEST_BUILD_DIR = 'tests/build'


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


# Compile the given coffeescript files.
def compile(source_dir, build_dir, watch=false)
  opts = (watch) ? '--watch' : ''
  sh("coffee #{opts} -o #{build_dir} -c #{source_dir}")
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

  def compile_tests(watch=false)
    compile(TEST_SOURCE_DIR, TEST_BUILD_DIR, watch)
  end

  desc "Compile test code."
  task "compile" do
    compile_tests()
  end

  desc "Compile test code when it changes."
  task "compile:watch" do
    compile_tests(true)
  end

  task "browser" => [:build] do
    open("tests/tests.html")
  end

end

desc "Run tests in a browser."
task "test" => ["test:browser"]

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
