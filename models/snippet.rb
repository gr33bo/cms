class Snippet < Sequel::Model
  plugin :timestamps, :update_on_create => true 
  
  many_to_one :snippet_folder
  
end