class ServiceTerraformTemplate < ServiceGeneric
  delegate :terraform_template, :to => :service_template, :allow_nil => true

  def my_zone
    miq_request&.my_zone
  end

  def execute(action)
    task_opts = {
      :action => "Launching Terraform Template",
      :userid => "system"
    }

    queue_opts = {
      :args        => [action],
      :class_name  => self.class.name,
      :instance_id => id,
      :method_name => "launch_terraform_template",
      :role        => "embedded_terraform",
      :zone        => my_zone
    }

    task_id = MiqTask.generic_action_with_callback(task_opts, queue_opts)
    task    = MiqTask.wait_for_taskid(task_id)
    raise task.message unless task.status_ok?
  end

  def check_completed(action)
    status  = stack(action).raw_status
    done    = status.completed?
    message = nil
    [done, message]
  rescue MiqException::MiqOrchestrationStackNotExistError, MiqException::MiqOrchestrationStatusError => err
    [true, err.message] # consider done with an error when exception is caught
  end

  def launch_terraform_template(action)
    terraform_template = terraform_template(action)

    stack = ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Stack.create_stack(terraform_template, options)
    add_resource!(stack, :name => action)
  end

  def stack(action)
    service_resources.find_by(:name => action, :resource_type => 'OrchestrationStack').try(:resource)
  end
end
