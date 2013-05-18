require "pathname"
require 'fileutils'

# General Language Pack module
module BinaryDependencies
  GEOS_URL = ["geos", "https://s3.amazonaws.com/camenischcreative/heroku-binaries/rgeo/geos-3.3.tgz"]
  PROJ_URL = ["proj", "https://s3.amazonaws.com/camenischcreative/heroku-binaries/rgeo/proj-4.8.tgz"]
  DEPENDENCIES = [GEOS_URL, PROJ_URL]

  # vendors required binary dependencies
  # @param [Array] first argument is a String of the build directory
  # @return +nil+
  def self.vendor(*args)
    ::Dir.chdir(args.first)
    DEPENDENCIES.each do |name, url|
      bin_dir = "vendor/#{name}"
      ::FileUtils.mkdir_p bin_dir

      puts "Downloading #{name} from #{url}"
      ::Dir.chdir(bin_dir) do |dir|
        run("curl #{url} -s -o - | tar xzf -")
      end
    end
  end

  def self.run(command)
    %x{ #{command} 2>&1 }
  end

end
