require_relative 'spec_helper'
 
class TestSite < Minitest::Test
  def setup
    @site = Site.create(:domain => 'localhost')
    @root_folder = Folder.create(:slug => "/", :name => "Root")
    @site.root_site_node_id = @root_folder.id
    @site.save
    
    @home_page = Page.create(:title => "Home", :slug => "index", :parent_id => @root_folder.id)
    
    @sub_folder = Folder.create(:name => "Images", :parent_id => @root_folder.id)
    
    @sub_folder_page1 = Page.create(:title => "Foo", :slug => "foo", :parent_id => @sub_folder.id)
    @sub_folder_page2 = Page.create(:title => "Bar", :slug => "bar", :parent_id => @sub_folder.id)
  end

  def test_that_port_is_correctly_added
    assert_equal "localhost:8080", @site.domain
  end

  def test_find_home_page_1
    root_node = @site.find_by_url("/")
    
    assert_equal root_node.id, @home_page.id
  end

  def test_find_home_page_2
    root_node = @site.find_by_url("/index")
    
    assert_equal root_node.id, @home_page.id
  end
  
  def test_find_home_page_3
    root_node = @site.find_by_url("/index/")
    
    assert_equal root_node.id, @home_page.id
  end
    
  def test_find_images_folder_foo_page
    page = @site.find_by_url("/images")
    
    assert_equal page.id, @sub_folder_page1.id
  end
    
  def test_find_bar_page
    page = @site.find_by_url("/images/bar")
    
    assert_equal page.id, @sub_folder_page2.id
  end
  
  def test_page_not_found
    page = @site.find_by_url('/blah')
    
    assert_equal page, false
  end
  
end




#describe "Messages API" do
#  before(:all) do
#    puts "before all"
#  end
 #
#  it 'sends a list of messages' do
##    FactoryGirl.create_list(:message, 10)
#
#    get '/test'
#
#    expect(last_response.status).to eq(200)    # test for the 200 status-code
#    json = JSON.parse(last_response.body)
#    expect(json['success']).to eq(true) # check to make sure the right amount of messages are returned
#  end
#end
 