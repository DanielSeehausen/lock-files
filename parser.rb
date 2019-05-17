require 'bundler'
require 'set'
require 'json'

dependency_names = Set.new
versions = {}

Dir.glob('files/*.lock') do |lockfile|
  parsed_lockfile = Bundler::LockfileParser.new(File.read(lockfile))

  dependencies = parsed_lockfile.dependencies
  dependency_names.merge(dependencies.keys)
  
  specs = parsed_lockfile.specs
  spec_count = specs.map do |spec|
    spec_name = spec.name
    spec_version = spec.version.version

    if versions[spec_name].nil? 
      versions[spec_name] = {}
    end

    if versions[spec_name][spec_version].nil?
      versions[spec_name][spec_version] = 1
    else 
      versions[spec_name][spec_version] += 1
    end
  end
end

filtered_versions = versions.slice(*dependency_names.to_a)
puts filtered_versions.to_json
