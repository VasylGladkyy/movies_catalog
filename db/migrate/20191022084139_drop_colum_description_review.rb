# frozen_string_literal: true

class DropColumDescriptionReview < ActiveRecord::Migration[6.0]
  def change
    remove_column :reviews, :description
  end
end
