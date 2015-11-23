Bundler.require
Dotenv.load

module PizzaCone
  class Configuration
    DEFAULT_SSH_CONFIG_FILE_PATH = "~/.ssh/config"
    DEFAULT_BACKUP_SSH_CONFIG_FILE_PATH = "~/.ssh/config.bak"

    attr_writer :ssh_config_file_path, :backup_ssh_config_file_path, :hostname_block

    def ssh_config_file_path
      @ssh_config_file_path || DEFAULT_SSH_CONFIG_FILE_PATH
    end

    def backup_ssh_config_file_path
      @backup_ssh_config_file_path || DEFAULT_BACKUP_SSH_CONFIG_FILE_PATH
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.update_config
    instances = OpsworksWrapper.new.instances
    writer = SSHConfigWriter.new(instances)
    writer.write
  end
end

require "pizza_cone/instance_wrapper"
require "pizza_cone/opsworks_wrapper"
require "pizza_cone/ssh_config_parser"
require "pizza_cone/ssh_config_writer"