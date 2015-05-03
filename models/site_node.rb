class SiteNode < Sequel::Model
  plugin :timestamps, :update_on_create => true

  plugin :tree, :key=>:parent_id, :order=>:order_by
  plugin :class_table_inheritance, :key => :kind
  plugin :validation_helpers


  def before_create
    if !order_by || order_by == 0
      max_order_by = DB[:site_nodes].where(:parent_id => parent_id).max(:order_by)
      if !max_order_by || max_order_by == 0
        self.order_by = 1
      else
        self.order_by = max_order_by + 1
      end
    end
    if !self.slug
      self.slug = name.downcase.gsub(/\W/, '').split(" ").join("-")
    end
    super
  end

  def validate
    super
    unless !parent_id
      validates_unique(:slug){|ds| ds.where(:parent_id => parent_id).where(Sequel.~(:site_nodes__id => id))}
    end
  end

  def url
    if parent?
      parent.child_url(self)
    else
      slug
    end
  end

  def child_url(child)
    if(url == '/')
      url + child.slug
    else
      url + '/' + child.slug
    end
  end

  def root?
    slug == '/'
  end

  def parent?
    !parent.nil?
  end
  
  def find_by_url(url)
    my_url = self.url
    
    #If my url is the desired url or the desired url with closing slash
    if (my_url == url || (url =~ /(^.*)\/$/ && my_url == $1))
   
      if self.class == Folder
        #If folder: get "./index" child or first child
        index_child = Page[:parent_id => self.id, :slug => "index"]
        if index_child
          return index_child
        else
          page_child = Page[:parent_id => self.id]
          if page_child
            return page_child
          else
            return false
            #No displayable child for folder
          end
          
        end
      else
        #Return the site node
        return self
      end
      
      #If my url is part of the desired url
    elsif(url =~ /^#{Regexp.quote(my_url)}([^\/]*)/)
      #Check my children
      children.each do |child|
        found = child.find_by_url(url)
        
        return found if found
      end
      
      return false
    end
  end

end


class Page < SiteNode

  def before_create 
    if !self.name      
      self.name = title
    end
    if !self.slug
      self.slug = title.downcase.gsub(/\W/, '').split(" ").join("-")
    end
    super
  end
end

class Folder < SiteNode

  def after_create

  end
  
end
