require 'yaml'

class TestConfig
  def self.[] key
    @@testconfig[key]
  end

  #These methods define and load the testconfig.yml file which sets 
  #various key-value pairs for the env class which controls the behavior 
  #of the test system and of webdriver
  
  def self.load (name)
    @@testconfig = nil
    io = File.open( File.dirname(__FILE__) + "/testconfig.yml" )
    YAML::load_stream(io) { |doc| @@testconfig = doc[name] }
    raise "Could not locate a configuration named \"#{name}\"" unless @@testconfig
  end

  def self.[]= key, value
    @@testconfig[key] = value
  end

  def screen_dir
    savepoint = Dir.pwd + '/features/screenshots/' + Time.now.to_date.to_s + '/'
    return savepoint 
  end
  
end

TestConfig.load(ENV['TEST_ENV'])
