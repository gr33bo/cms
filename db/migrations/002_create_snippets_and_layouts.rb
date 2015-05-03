Sequel.migration do
  up do
    create_table(:snippet_folders) do
      primary_key :id
      foreign_key :parent_id, :snippet_folders
      Text :name, :null => false
      Integer :order_by, :null => false
      
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false
    end

    create_table(:layout_folders) do
      primary_key :id
      foreign_key :parent_id, :layout_folders
      Text :name, :null => false
      Integer :order_by, :null => false
      
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false
    end
    
    create_table(:snippets) do
      primary_key :id
      foreign_key :snippet_folder_id, :snippet_folders
      Text :name, :null => false
      Text :content, :null => false
      
      Text :keywords
      
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false
    end
    
    
    
    create_table(:layouts) do
      primary_key :id
      foreign_key :layout_folder_id, :layout_folders
      Text :name, :null => false
      Text :content, :null => false
      Text :content_type
      
      Text :keywords
      
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false
    end


  end
  
  down do
    drop_table :layouts
    drop_table :snippets
    drop_table :layout_folders
    drop_table :snippet_folders
  end
  
end
