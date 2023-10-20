# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    can_update?
  end

  def new?
    can_update?
  end

  def show?
    can_update?
  end

  def create?
    can_update?
  end

  def edit?
    can_update?
  end

  def update?
    can_update?
  end

  def destroy?
    @user.admin?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise(NotImplementedError, "You must define #resolve in #{self.class}")
    end

    def authorized_user?
      @user.present?
    end

    private

    attr_reader :user, :scope
  end

  private

  def can_update?
    @user.present?
  end
end
