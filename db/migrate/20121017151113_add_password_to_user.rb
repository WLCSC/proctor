class AddPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_address, :string

    add_column :users, :password_hash, :string

    add_column :users, :password_salt, :string

  end
end
