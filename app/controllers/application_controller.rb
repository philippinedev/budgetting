# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def routing_error
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
