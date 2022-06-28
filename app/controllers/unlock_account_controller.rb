# module Accounts
#   class UnlockAccountController < ApplicationController
#     skip_before_action :require_login, only: :show
#     def show
#       @user = User.load_from_unlock_token(params[:token])
#       if @user
#         @user.login_unlock!
#         redirect_to root_path, success: t('.login_unlock')
#       else
#         not_authenticated
#       end
#     end
#   end
# end
