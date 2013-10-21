class Authentication
  def initialize(params="")
    @params = params
  end

  def authenticated?
    user.present? && !user.state_suspended?
  end

  def user
    @user ||= user_with_password
  end

  def matches?(request)
    request.cookies.has_key?("auth_token")
  end

private

  def user_with_password
    user = User.find_by(email: @params[:signin][:email]) if @params.present?
    user if user && user.authenticate(@params[:signin][:password])
  end
end