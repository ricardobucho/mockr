# frozen_string_literal: true

class ClientPolicy < ApplicationPolicy
  def index?
    manager?
  end

  def show?
    manager?
  end

  def create?
    manager?
  end

  def update?
    manager?
  end

  def destroy?
    manager?
  end
end
