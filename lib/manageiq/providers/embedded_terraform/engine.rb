module ManageIQ
  module Providers
    module EmbeddedTerraform
      class Engine < ::Rails::Engine
        isolate_namespace ManageIQ::Providers::EmbeddedTerraform

        config.autoload_paths << root.join('lib').to_s

        initializer :append_secrets do |app|
          app.config.paths["config/secrets"] << root.join("config", "secrets.defaults.yml").to_s
          app.config.paths["config/secrets"] << root.join("config", "secrets.yml").to_s
        end

        def self.vmdb_plugin?
          true
        end

        def self.plugin_name
          _('Embedded Terraform Provider')
        end

        def self.init_loggers
          $embedded_terraform_log ||= Vmdb::Loggers.create_logger("embedded_terraform.log")
        end

        def self.apply_logger_config(config)
          Vmdb::Loggers.apply_config_value(config, $embedded_terraform_log, :level_embedded_terraform)
        end
      end
    end
  end
end
