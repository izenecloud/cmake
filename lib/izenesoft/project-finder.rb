# Try to find dependent project

require "izenesoft/string-patch"
include Rake::DSL

module IZENESOFT
  class ProjectFinder
    def initialize(current_project_dir)
      @current_project_dir = current_project_dir
      @branch = begin File.read(File.join(@current_project_dir, ".git", "HEAD")).sub(/^.*\//, "").chomp rescue "master" end
      @dependencies = []

      desc "Display dependencies"
      task :show_dep do
        puts @dependencies.join(",")
      end
    end

    # name : project repository name
    # file : a file should exist in the project
    # env_name: the env variable name should be set the the project directory
    def find(name_or_names, file, env_name = nil)
      names = [name_or_names].flatten
      @dependencies << names.first
      env_name ||= names.first.upcase

      if ENV["HUDSON_URL"] # in hudson
        # if in Hudson, try to copy the archived binary package
        packages = names.map do |name|
          Dir[".dep/#{name}-*.tar.bz2"] +
            Dir[File.join(@current_project_dir, "..", "..", "#{name}--#{@branch}", "lastSuccessful", "archive", "build", "#{name}-*.tar.bz2")] +
            Dir[File.join(@current_project_dir, "..", "..", "#{name}--master", "lastSuccessful", "archive", "build", "#{name}-*.tar.bz2")]
        end
        packages = packages.flatten.compact
        package = packages.first
        if package
          Dir.chdir @current_project_dir do
            mkdir ".dep" unless File.exists? ".dep"
            package_base_name = File.basename(package)
            package_base_name_no_ext = package_base_name.sub(/\.tar\.bz2$/, "")

            unless File.exists? File.join(".dep", package_base_name_no_ext)
              cp package, ".dep"
              Dir.chdir ".dep" do
                sh "bunzip2 -c #{package_base_name.shell_escape} | tar -x"
              end
            end
            ENV[env_name] = File.expand_path(File.join(".dep", package_base_name_no_ext))
          end
        end
      end

      dirs = names.map do |name|
        [
         File.join(@current_project_dir, "..", name, "pkg"),
         File.join(@current_project_dir, "..", name),
         File.join(@current_project_dir, "..", "..", "#{name}--#{@branch}", "lastSuccessful", "archive", "pkg"),
         File.join(@current_project_dir, "..", "..", "#{name}--workspace", "lastSuccessful", "archive", "pkg"),
         File.join(@current_project_dir, "..", "..", "#{name}--#{@branch}", "workspace"),
         File.join(@current_project_dir, "..", "..", "#{name}--master", "workspace"),
         File.join(@current_project_dir, "..", "..", name)
        ]
      end
      dirs = dirs.flatten
      dirs.unshift ENV[env_name] if ENV[env_name]

      dirs.each do |dir|
        dir = File.expand_path(dir)
        if File.exists? File.join(dir, file)
          ENV[env_name] = dir
          break
        end
      end
    end

    def find_izenelib
      find("izenelib", "include/am/am.h")
    end

    def find_icma
      find("icma", "include/icma/analyzer.h", "IZENECMA")
    end

    def find_ijma
      find("ijma", "include/ijma/analyzer.h", "IZENEJMA")
    end

    def find_ilplib
      find("ilplib", "include/ilplib.h")
    end

    def find_imllib
      find("imllib", "include/ml/Categorizer.h")
    end

    def find_idmlib
      find("idmlib", "include/idmlib/idm_types.h")
    end

    def find_iise
      find(["iise", "iise-v1"], "include/ise-wrapper.h", "IISE_ROOT")
    end

    def find_kma
      names = ["wisekma", "kma"]
      if RUBY_PLATFORM =~ /64/
        names << "wisekma/ia64-glibc27-gcc41"
        names << "kma/ia64-glibc27-gcc41"
      end
      names << "wisekma/ia32-glibc27-gcc41"
      names << "kma/ia32-glibc27-gcc41"

      find(names, "interface/wk_analyzer.h")
    end

    def find_libxml2
      env_name = "LIBXML2"
      dirs = ["/usr/include/libxml2", "/usr/local/include/libxml2", "/usr/include", "/usr/local/include"]
      dirs.unshift ENV[env_name] if ENV[env_name]

      file = "libxml/xmlreader.h"
      dirs.each do |dir|
        dir = File.expand_path(dir)
        if File.exists? File.join(dir, file)
          ENV[env_name] = dir
          break
        end
      end
    end
  end
end
