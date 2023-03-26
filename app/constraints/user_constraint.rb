class UserConstraint
  def initialize(&block)
    @block = block
  end

  def matches?(request)
    user = current_user(request)
    user.present? && @block.call(user)
  end

  private

  def current_user(request)
    return if request.session[:user_id].blank?

    User.find(request.session[:user_id])
  end
end
