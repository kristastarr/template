helpers do
  def current_user
    @user = nil
    if session['user_id']
      @user = User.find(session['user_id'])
    end
    @user
  end
end
