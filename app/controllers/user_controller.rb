# frozen_string_literal: true

class UserController < ApplicationController
  def regenerate_token
    current_user.update!(
      token: User.generate_token,
    )

    render "_regenerate_token"
  end
end
