Rails.application.routes.draw do
  get "embedded_terraform_template", :controller => :embedded_terraform_template, :action => :index
  post "embedded_terraform_template/report_data(/:id)", :action => :report_data, :controller => :embedded_terraform_template
  get "embedded_terraform_template/map_credentials(/:id)", :action => :map_credentials, :controller => :embedded_terraform_template
  get "embedded_terraform_template/download_data(/:id)", :action => :download_data, :controller => :embedded_terraform_template
  get "embedded_terraform_template/download_summary_pdf(/:id)", :action => :download_summary_pdf, :controller => :embedded_terraform_template
  get "embedded_terraform_template/show(/:id)", :action => :show, :controller => :embedded_terraform_template
  get "embedded_terraform_template/show_list(/:id)", :action => :show_list, :controller => :embedded_terraform_template
  get "embedded_terraform_template/tagging_edit(/:id)", :action => :tagging_edit, :controller => :embedded_terraform_template
  post "embedded_terraform_template/search_clear(/:id)", :action => :search_clear, :controller => :embedded_terraform_template
  post "embedded_terraform_template/button(/:id)", :action => :button, :controller => :embedded_terraform_template
  post "embedded_terraform_template/show_list(/:id)", :action => :show_list, :controller => :embedded_terraform_template
  post "embedded_terraform_template/tagging_edit(/:id)", :action => :tagging_edit, :controller => :embedded_terraform_template

  get "embedded_terraform_repository", :controller => :embedded_terraform_repository, :action => :index
  post "embedded_terraform_repository/report_data(/:id)", :action => :report_data, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/download_data(/:id)", :action => :download_data, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/download_summary_pdf(/:id)", :action => :download_summary_pdf, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/edit(/:id)", :action => :edit, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/new(/:id)", :action => :new, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/show(/:id)", :action => :show, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/show_list(/:id)", :action => :show_list, :controller => :embedded_terraform_repository
  get "embedded_terraform_repository/tagging_edit(/:id)", :action => :tagging_edit, :controller => :embedded_terraform_repository
  post "embedded_terraform_repository/button(/:id)", :action => :button, :controller => :embedded_terraform_repository
  post "embedded_terraform_repository/edit(/:id)", :action => :edit, :controller => :embedded_terraform_repository
  post "embedded_terraform_repository/new(/:id)", :action => :new, :controller => :embedded_terraform_repository
  post "embedded_terraform_repository/repository_refresh(/:id)", :action => :repository_refresh, :controller => :embedded_terraform_repository
  post "embedded_terraform_repository/show_list(/:id)", :action => :show_list, :controller => :embedded_terraform_repository
  post "embedded_terraform_repository/tagging_edit(/:id)", :action => :tagging_edit, :controller => :embedded_terraform_repository

  get "embedded_terraform_credential", :controller => :embedded_terraform_credential, :action => :index
  post "embedded_terraform_credential/report_data(/:id)", :action => :report_data, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/download_data(/:id)", :action => :download_data, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/download_summary_pdf(/:id)", :action => :download_summary_pdf, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/edit(/:id)", :action => :edit, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/new(/:id)", :action => :new, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/show(/:id)", :action => :show, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/show_list(/:id)", :action => :show_list, :controller => :embedded_terraform_credential
  get "embedded_terraform_credential/tagging_edit(/:id)", :action => :tagging_edit, :controller => :embedded_terraform_credential
  post "embedded_terraform_credential/search_clear(/:id)", :action => :search_clear, :controller => :embedded_terraform_credential
  post "embedded_terraform_credential/button(/:id)", :action => :button, :controller => :embedded_terraform_credential
  post "embedded_terraform_credential/show_list(/:id)", :action => :show_list, :controller => :embedded_terraform_credential
  post "embedded_terraform_credential/tagging_edit(/:id)", :action => :tagging_edit, :controller => :embedded_terraform_credential
end
