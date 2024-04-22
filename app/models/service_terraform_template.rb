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

  def launch_terraform_template(action)
    job = terraform_template(action).run(options)
    add_resource!(job, :name => action)
  end
end
