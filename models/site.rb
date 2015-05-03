class Site < Sequel::Model
  plugin :timestamps, :update_on_create => true  
  
  many_to_one :root_site_node, :class => :SiteNode
  
  def find_by_url(url)
    root_site_node.find_by_url(url)
    #TODO need to throw/handle exception if home page not found
  end

  def domain
    ret = self[:domain]
    ret = ret + ":8080" if ret == 'localhost'
    ret
  end

end