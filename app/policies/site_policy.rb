class SitePolicy < ApplicationPolicy
  def update?
    user.admin?
  end

  def delete_image_attachment?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
