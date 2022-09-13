module SessionHelper
  def correct_user?(user)
    user && user == current_user
  end
end
