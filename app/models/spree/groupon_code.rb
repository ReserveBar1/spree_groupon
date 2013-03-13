class Spree::GrouponCode < ActiveRecord::Base

  belongs_to :promotion, :foreign_key => 'activator_id'
  belongs_to :order
  

  validates :code, :presence => true, :uniqueness => { :case_sensitive => true }
  validates :activator_id, :presence => true
  
  scope :unused, where(:used_at => nil)
  
  attr_accessible :used_at, :order_id, :campaign, :code, :activator_id
  
  search_method :used_at
  search_method :campaign


end
