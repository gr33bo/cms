Sequel.migration do
  up do
    create_table(:site_nodes) do
      primary_key :id
      foreign_key :parent_id, :site_nodes
      Text :kind, :null => false

      Text :name, :null => false
      Text :slug, :null => false

      Integer :order_by, :null => false, :default => 0
      
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false
    end



    create_table(:folders) do
       foreign_key :id, :site_nodes, :unique => true
    end
    
    create_table(:pages) do
      foreign_key :id, :site_nodes, :unique => true
       
      Text :title
      
    end
    
    create_table(:sites) do
      primary_key :id
      foreign_key :root_site_node_id, :site_nodes
      Text :domain
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false
    end

  end
  
  down do
    drop_table :sites
    drop_table :folders
    drop_table :site_nodes
  end
  
end
