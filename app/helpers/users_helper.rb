module UsersHelper

  def user_submit(user, current_user)
    if user.id == current_user.id
      myaccount_path
    else
      user_path(user)
    end
  end

end
