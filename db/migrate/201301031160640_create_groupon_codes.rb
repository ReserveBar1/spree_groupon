class CreateGrouponCodes < ActiveRecord::Migration
  
  def change
    create_table :spree_groupon_codes do |t|
      t.string :code, :null => false, :default => ''  # Unique coupon code
      t.string :campaign, :null => false, :default => '' # Human readable campaign name, inforamtional only
      t.datetime :used_at   # set to Time.now when the user has added the code to an order
      t.references :order # set the the specific order a code is used for
      t.references :activator # set initially to find all groupon codes for a given promotion
      t.timestamps
    end
    add_index :spree_groupon_codes, :code
    add_index :spree_groupon_codes, :activator_id
    add_index :spree_groupon_codes, :order_id
  end

end
