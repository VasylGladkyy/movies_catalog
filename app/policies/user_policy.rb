class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def index?
    user.admin?
  end

  def show?
    user.id == record.id
  end

  def update?
    user.admin?
  end

  def toggle_account_status?
    user.admin?
  end
  
  def watch_later?
    user.id == record.id
  end

  def destroy_watch_later?
    user.id == record.id
  end

  def refresh?
    user.admin?
  end
end
