#--
# Author::  Ian Yang
# Created:: <2010-07-27 13:05:38>
#++
#
# CMake task
require "rake"
require "rake/tasklib"
include Rake::DSL

require "izenesoft/string-patch"

module IZENESOFT

  # Only use default Makefile generator on *nix platform.
  class CMake < Rake::TaskLib
    attr_accessor :name
    attr_accessor :build_type
    attr_accessor :source_dir
    attr_accessor :build_dir
    attr_accessor :install_dir
    attr_accessor :cmake_bin
    attr_accessor :make_bin

    def initialize(opts = {})
      @name = opts.delete(:name) || "cmake"
      @build_type = opts.delete(:build_type)
      @source_dir = opts.delete(:source_dir) || "source"
      @build_dir = opts.delete(:build_dir) || "build"
      @install_dir = opts.delete(:install_dir) || "pkg"
      @cmake_bin = opts.delete(:cmake_bin) || "cmake"
      @make_bin = opts.delete(:make_bin) || "make"

      @install_dir = File.expand_path(@install_dir)
      @parameters = {}
      (opts.delete(:parameters) || {}).each_pair do |k, v|
        @parameters[k.to_sym] = v
      end
      @config_file = "cmake.yml"

      throw ArgumentError, "Unknown options #{opts.keys.join(", ")}" unless opts.empty?

      yield self if block_given?

      if File.exists? @config_file
        YAML::load_file(@config_file).each_pair do |k, v|
          self[k] = v
        end
      end

      define
    end

    def [](key)
      @parameters[key.to_sym]
    end

    def []=(key, value)
      if key.to_sym == :CMAKE_BUILD_TYPE
        @build_type = value
      elsif key.to_sym == :CMAKE_INSTALL_PREFIX
        @install_dir = File.expand_path(value)
      else
        @parameters[key.to_sym] = value
      end
    end

    def cmake_args
      @parameters[:CMAKE_INSTALL_PREFIX] = @install_dir
      @parameters.map {|(k, v)| "-D #{k}=#{v.to_s.shell_escape}"}.join(" ")
    end

    def define
      directory build_dir

      desc "Generate Makefile"
      task "#{name}:generate", [:build_type] => build_dir do |t, args|
        cmake_build_type_arg = build_type || args[:build_type] || ""
        unless cmake_build_type_arg.empty?
          cmake_build_type_arg = "-D CMAKE_BUILD_TYPE=#{cmake_build_type_arg.shell_escape}"
        end

        source_dir_absolute_path = File.expand_path(source_dir)
        Dir.chdir build_dir do
          sh "#{cmake_bin.shell_escape} #{cmake_args} #{cmake_build_type_arg} #{source_dir_absolute_path.shell_escape}"
        end
      end

      makefile_file = File.join(build_dir, "Makefile")
      file makefile_file => "#{name}:generate"

      desc "Project Build"
      task "#{name}:build", [:build_type] => makefile_file do
        sh "#{make_bin.shell_escape} -C #{build_dir}"
      end

      desc "Project Clean"
      task "#{name}:clean" => makefile_file do
        sh "#{make_bin.shell_escape} -C #{build_dir} clean"
      end

      desc "Project Clean Build"
      task "#{name}:rebuild", [:build_type] => ["#{name}:clean", "#{name}:build"]

      desc "Generate and Project Build"
      task name, [:build_type] => ["#{name}:generate", "#{name}:build"]

      desc "Remove build dir and rebuild using CMake"
      task "#{name}:force", [:build_type] => ["#{name}:clobber", name]

      desc "Install in #{install_dir}"
      task "#{name}:install", [:build_type] => makefile_file do
        sh "#{make_bin.shell_escape} -C #{build_dir} install"
      end

      desc "Package"
      task "#{name}:package", [:build_type] => makefile_file do
        sh "#{make_bin.shell_escape} -C #{build_dir} package"
      end

      desc "Call make"
      task "#{name}:make", [:target] => makefile_file do |t, args|
        sh "#{make_bin.shell_escape} -C #{build_dir} #{args[:target]}"
      end
      
      desc "Remove CMake build dir"
      task "#{name}:clobber" do
        rm_r build_dir if File.exists?(build_dir)
      end
      task :clobber => "clobber_#{name}"
    end
  end
end
