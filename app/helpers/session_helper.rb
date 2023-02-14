module SessionHelper
  def correct_user?(user, current_user)
    user && user == current_user
  end
end
