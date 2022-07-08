class TogoInuShitsukeHiroba::StaticPagesController < ApplicationController
  skip_before_action :require_login
  layout 'togo_inu_shitsuke_hiroba'
  def top; end
  def compliance_confirmations; end
end
