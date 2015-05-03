class Layout < Sequel::Model
  plugin :timestamps, :update_on_create => true 
  
  many_to_one :layout_folder
  
end