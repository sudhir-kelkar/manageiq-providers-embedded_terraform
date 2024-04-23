module Terraform
  class Runner
    class ApiParams
      # Add parameter in format required by terraform-runner api
      def self.add_param(param_list, param_value, param_name, is_secured: false)
        if param_list.nil?
          param_list = []
        end

        param_list.push(to_cam_param(param_name, param_value, :is_secured => is_secured))

        param_list
      end

      # add parameter, only if not blank or not nil,
      def self.add_param_if_present(param_list, param_value, param_name, is_secured: false)
        if param_value.present?
          param_list = add_param(param_list, param_value, param_name, :is_secured => is_secured)
        end

        param_list
      end

      # convert to format required by terraform-runner api
      def self.to_cam_param(param_name, param_value, is_secured: false)
        {
          'name'    => param_name,
          'value'   => param_value,
          'secured' => is_secured ? 'true' : 'false',
        }
      end

      # Convert to paramaters as used by terraform-runner api
      #
      # @param vars [Hash] Hash with key/value pairs that will be passed as input variables to the
      #        terraform-runner run
      # @return [Array] Array of {:name,:value}
      def self.to_cam_parameters(vars)
        return [] if vars.nil?

        vars.map do |key, value|
          to_cam_param(key, value)
        end
      end
    end
  end
end
