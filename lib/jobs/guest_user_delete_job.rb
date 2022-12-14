class GuestUserDeleteJob
  def call
    User.where(role: 'guest').delete_all
  end
end
