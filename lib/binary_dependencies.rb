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
    lib_so_conf_dir = "/etc/ld.so.conf.d"
    ::FileUtils.mkdir_p(lib_so_conf_dir)

    DEPENDENCIES.each do |name, url|
      bin_dir = "vendor/#{name}"
      ::FileUtils.mkdir_p bin_dir


      puts "Downloading #{name} from #{url}"
      ::Dir.chdir(bin_dir) do |dir|
        run("curl #{url} -s -o - | tar xzf -")
        ::File.open("#{pwd}/#{lib_so_conf_dir}/#{name}.conf", 'w') do |file|
          file.write("/app/bin/#{name}/lib")
        end
      end
    end
  end

  def self.run(command)
    %x{ #{command} 2>&1 }
  end

  def pwd
    `pwd`.chomp
  end


end
