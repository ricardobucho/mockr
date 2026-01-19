# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    manager?
  end

  def show?
    manager?
  end

  def update?
    manager?
  end

  # Users cannot be created or destroyed via admin
  # They are created through OAuth
  def create?
    false
  end

  def destroy?
    false
  end
end
