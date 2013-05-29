require 'yaml'
require 'pp'
pp YAML.load(File.read("./example_config.json"))

