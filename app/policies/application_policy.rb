# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
  # By default, deny all actions
  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def manager?
    user&.manager?
  end
end
