require "manageiq/providers/embedded_terraform/engine"
require "manageiq/providers/embedded_terraform/version"

module ManageIQ
  module Providers
    module EmbeddedTerraform
      def self.seed
        ManageIQ::Providers::EmbeddedTerraform::AutomationManager.in_my_region.first_or_create!(
          :name => "Embedded Terraform",
          :zone => MiqServer.my_server.zone
        )
      end
    end
  end
end
