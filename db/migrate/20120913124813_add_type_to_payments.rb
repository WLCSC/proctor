class AddTypeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :kind, :string

  end
end
