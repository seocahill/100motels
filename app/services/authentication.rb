class Authentication
  def initialize(params)
    @params = params
  end

  def authenticated?
    user.present? && !user.state_suspended?
  end

  def user
    @user ||= user_with_password
  end

private

  def user_with_password
    member = MemberProfile.find_by_email(@params[:email])
    if member && member.authenticate(@params[:password])
      member.user
    end
  end
end