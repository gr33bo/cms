class LayoutFolder < Sequel::Model
  
  include Tree
  
  plugin :timestamps, :update_on_create => true 
  plugin :tree, :key=>:parent_id, :order=>:order_by
  plugin :association_dependencies
  
  one_to_many :layouts, :order => :name
  
  
  add_association_dependencies :layouts => :destroy
  add_association_dependencies :children => :destroy
  
  
end