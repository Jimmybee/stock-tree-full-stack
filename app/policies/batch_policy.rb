class BatchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(product: { team: :teams_users }).where(teams_users: { user_id: user.id })
    end
  end

  def show?
    in_scope?
  end

  def create?
    in_scope_for_product?
  end

  def update?
    in_scope?
  end

  def destroy?
    in_scope?
  end

  private

  def in_scope?
    Scope.new(user, Batch).resolve.where(id: record.id).exists?
  end

  def in_scope_for_product?
    ProductPolicy::Scope.new(user, Product).resolve.where(id: record.product_id).exists?
  end
end
