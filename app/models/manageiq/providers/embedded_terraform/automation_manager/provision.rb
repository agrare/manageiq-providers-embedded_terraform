class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Provision < ManageIQ::Providers::AutomationManager::Provision
  include module_parent::TerraformRunnerMixin
  include StateMachine

  TASK_DESCRIPTION = N_("Terraform Template Provision")

  # Virtual attribute: when provided, resolves the ConfigurationScript by
  # scm_url, scm_branch, and template name, then populates source_id / source_type.
  #
  # @param ref [Hash] with keys :scm_url, :scm_branch, and :name
  def configuration_script_ref=(ref)
    return if ref.blank?

    script_source = ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ConfigurationScriptSource
                      .find_by(:scm_url => ref["scm_url"], :scm_branch => ref["scm_branch"])
    return if script_source.nil?

    script = ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ConfigurationScript
               .find_by(:configuration_script_source_id => script_source.id, :name => ref["name"])
    return if script.nil?

    self.source = script
  end
end
