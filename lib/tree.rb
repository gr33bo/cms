module Tree
  
  def before_create
    if !self.order_by || self.order_by == 0
      max_order_by = self.class.where(:parent_id => self.parent_id).max(:order_by)
      if !max_order_by || max_order_by == 0
        self.order_by = 1
      else
        self.order_by = max_order_by + 1
      end
    end
    super
  end
  
  def after_destroy
    other_siblings = self.class.where("order_by > ?", self.order_by).where(:parent_id => self.parent_id).all

    other_siblings.each{|child|
      child.order_by = child.order_by - 1
      child.save
    }
    super
  end
  
  def move_after(tree_obj)
    if self.parent_id == tree_obj.parent_id
      current_order_by = self.order_by
        
      if current_order_by > tree_obj.order_by        
        new_order_by = tree_obj.order_by + 1
        
        siblings = self.class.where("order_by >= ?", new_order_by).
          where("order_by < ?", current_order_by).
          where(:parent_id => self.parent_id).all

        siblings.each{|sibling|
          sibling.order_by += 1
          sibling.save
        }
        
      
        self.order_by = new_order_by
        self.save
      elsif current_order_by < tree_obj.order_by     
        new_order_by = tree_obj.order_by 
        
        siblings = self.class.where("order_by <= ?", new_order_by).
          where("order_by > ?", current_order_by).
          where(:parent_id => self.parent_id).all
        
        siblings.each{|sibling|
          sibling.order_by -= 1
          sibling.save
        }
      
        self.order_by = new_order_by
        self.save
      end
    else
      old_parent = self.parent
      new_parent = tree_obj.parent
      new_order_by = tree_obj.order_by + 1
      
      new_siblings = self.class.where("order_by >= ?", new_order_by).
          where(:parent_id => new_parent.id).all
        
      new_siblings.each{|sibling|
        sibling.order_by += 1
        sibling.save
      }
      
      self.order_by = new_order_by
      self.parent_id = new_parent.id
      self.save
      
      old_parent.children.each_with_index{|child, i|
        child.order_by = i+1
        child.save
      }
    end
  end
  
  
  def move_before(tree_obj)
    if self.parent_id == tree_obj.parent_id
      current_order_by = self.order_by
        
      if current_order_by > tree_obj.order_by        
        new_order_by = tree_obj.order_by        
        
        siblings = self.class.where("order_by >= ?", new_order_by).
          where("order_by < ?", current_order_by).
          where(:parent_id => self.parent_id).all

        siblings.each{|sibling|
          sibling.order_by += 1
          sibling.save
        }
      
        self.order_by = new_order_by
        self.save
      elsif current_order_by < tree_obj.order_by      
        new_order_by = tree_obj.order_by - 1       
        
        siblings = self.class.where("order_by <= ?", new_order_by).
          where("order_by > ?", current_order_by).
          where(:parent_id => self.parent_id).all

        siblings.each{|sibling|
          sibling.order_by -= 1
          sibling.save
        } 
      
        self.order_by = new_order_by
        self.save
      end
    else
      old_parent = self.parent
      new_parent = tree_obj.parent
      new_order_by = tree_obj.order_by
      
      new_siblings = self.class.where("order_by >= ?", new_order_by).
          where(:parent_id => new_parent.id).all
        
      new_siblings.each{|sibling|
        sibling.order_by += 1
        sibling.save
      }
      
      self.order_by = new_order_by
      self.parent_id = new_parent.id
      self.save
      
      old_parent.children.each_with_index{|child, i|
        child.order_by = i+1
        child.save
      }
    end
  end
  
  def move_as_child_of(new_parent_obj)
    old_parent = self.parent
    
    max_order_by = self.class.where(:parent_id => new_parent_obj.id).max(:order_by)
    if !max_order_by || max_order_by == 0
      self.order_by = 1
    else
      self.order_by = max_order_by + 1
    end
    
    self.parent_id = new_parent_obj.id
    self.save
    
    
    old_parent.children.each_with_index{|child, i|
      child.order_by = i+1
      child.save
    }
  end
end