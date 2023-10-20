class VacationPolicy < ApplicationPolicy
  def new?
    !@user.admin?
  end

  def create?
    !@user.admin?
  end

  def destroy?
    @user.admin?
  end


  class Scope < Scope
    def resolve
      if @user.admin?
        @scope.admin_scope
      elsif authorized_user?
        @scope.where(user_id: @user)
      else
        @scope.none
      end
    end
  end
end
