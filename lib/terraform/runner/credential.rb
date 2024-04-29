module Terraform
  class Runner
    class Credential
      attr_reader :auth

      def self.new(authentication_id)
        auth_type = Authentication.find(authentication_id).type
        self == Terraform::Runner::Credential ? detect_credential_type(auth_type).new(authentication_id) : super
      end

      def self.detect_credential_type(auth_type)
        subclasses.index_by(&:auth_type)[auth_type] || Terraform::Runner::GenericCredential
      end

      def initialize(authentication_id)
        @auth = Authentication.find(authentication_id)
      end

      # Return connection_parameters as required for terraform_runner
      def connection_parameters
        []
      end

      def env_vars
        {}
      end
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), "*_credential.rb")).each { |f| require_dependency f }
