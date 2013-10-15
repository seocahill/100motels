class Authentication
  def initialize(params="")
    @params = params
  end

  def authenticated?
    user.present? && !user.state_suspended?
    true
  end

  def user
    @user ||= user_with_password
  end

  def matches?(request)
    request.cookies.has_key?("auth_token")
  end

private

  def user_with_password
    member = MemberProfile.find_by_email(@params[:signin][:email]) if @params.present?
    if member && member.authenticate(@params[:signin][:password])
      member.user
    end
  end
end