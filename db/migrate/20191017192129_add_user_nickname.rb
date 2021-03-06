# frozen_string_literal: true

class AddUserNickname < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :nickname, :string, unique: true
  end
end
