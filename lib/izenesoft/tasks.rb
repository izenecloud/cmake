# load env
["env.yml", "~/env.yml", "/etc/env.yml"].each do |file|
  if File.exists? file
    puts "LOAD environment variables from #{file}"
    YAML::load_file(file).each_pair do |k, v|
      ENV[k] = v
    end
    break
  end
end

require "izenesoft/cmake"
require "izenesoft/test"
