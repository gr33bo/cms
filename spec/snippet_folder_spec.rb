require_relative 'spec_helper'
 
class TestSnippet < Minitest::Test
  def setup
    @root_folder = SnippetFolder.create(:name => "Default")
    
    @folder_1 = SnippetFolder.create(:name => "Folder 1", :parent_id => @root_folder.id)
    @folder_2 = SnippetFolder.create(:name => "Folder 2", :parent_id => @root_folder.id)
    
    @folder_3 = SnippetFolder.create(:name => "Folder 3", :parent_id => @folder_1.id)
    @folder_4 = SnippetFolder.create(:name => "Folder 4", :parent_id => @folder_1.id)
    @folder_5 = SnippetFolder.create(:name => "Folder 5", :parent_id => @folder_1.id)
    @folder_6 = SnippetFolder.create(:name => "Folder 6", :parent_id => @folder_1.id)
    @folder_7 = SnippetFolder.create(:name => "Folder 6", :parent_id => @folder_1.id)
    @folder_8 = SnippetFolder.create(:name => "Folder 6", :parent_id => @folder_1.id)
    @folder_9 = SnippetFolder.create(:name => "Folder 6", :parent_id => @folder_1.id)
    
    @folder_10 = SnippetFolder.create(:name => "Folder 6", :parent_id => @folder_3.id)
    @folder_11 = SnippetFolder.create(:name => "Folder 11", :parent_id => @folder_3.id)
    @folder_12 = SnippetFolder.create(:name => "Folder 12", :parent_id => @folder_3.id)
    
    @snippet = Snippet.create(:snippet_folder_id => @folder_4.id, :name => '', :content => '')

  end
  
  def test_that_folder_1_order_by_is_zero
    assert_equal 1, @folder_1.order_by
  end
   
  def test_that_folder_3_order_by_is_zero
    assert_equal 1, @folder_3.order_by
  end
  
  def test_that_folder_2_order_by_is_one
    assert_equal 2, @folder_2.order_by
  end
  
  def test_that_folder_4_order_by_is_one
    assert_equal 2, @folder_4.order_by
  end
  
  def test_that_deleting_a_folder_causes_reorder
    @folder_4.destroy 
    
    @folder_3.reload
    @folder_5.reload
    
    assert_equal 1, @folder_3.order_by
    assert_equal 2, @folder_5.order_by
  end 
  
  def test_that_deleting_a_folder_causes_snippet_deletion
    @folder_4.destroy 
    
    snippet = Snippet[@snippet.id]
    
    assert_nil(snippet)
  end

  def test_that_deleting_a_folder_deletes_children_recursively
    @folder_1.destroy
    
    folder = SnippetFolder[@folder_10.id]
    
    assert_nil(folder)
  end
  
  def test_move_after_on_same_level_greater_to_lesser
    @folder_8.move_after(@folder_4)
    
    @folder_5.reload
    @folder_6.reload
    @folder_7.reload
    @folder_8.reload
    
    assert_equal 4, @folder_5.order_by
    assert_equal 5, @folder_6.order_by
    assert_equal 6, @folder_7.order_by
    assert_equal 3, @folder_8.order_by
  end
  
  
  def test_move_after_on_same_level_lesser_to_greater
    @folder_4.move_after(@folder_7)
    
    @folder_4.reload
    @folder_5.reload
    @folder_6.reload
    @folder_7.reload
    
    assert_equal 2, @folder_5.order_by
    assert_equal 3, @folder_6.order_by
    assert_equal 4, @folder_7.order_by
    assert_equal 5, @folder_4.order_by
  end
  
  def test_move_after_different_levels
    @folder_11.move_after(@folder_7)
    
    @folder_7.reload
    @folder_8.reload
    @folder_9.reload
    @folder_10.reload
    @folder_11.reload
    @folder_12.reload
    
    assert_equal 5, @folder_7.order_by
    assert_equal 6, @folder_11.order_by
    assert_equal 7, @folder_8.order_by
    assert_equal 8, @folder_9.order_by
    
    assert_equal 1, @folder_10.order_by
    assert_equal 2, @folder_12.order_by
  end
  
  def test_move_before_on_same_level_greater_to_lesser
    @folder_8.move_before(@folder_5)
    
    @folder_5.reload
    @folder_6.reload
    @folder_7.reload
    @folder_8.reload
    
    assert_equal 4, @folder_5.order_by
    assert_equal 5, @folder_6.order_by
    assert_equal 6, @folder_7.order_by
    assert_equal 3, @folder_8.order_by
  end
  
  
  def test_move_before_on_same_level_lesser_to_greater
    @folder_4.move_before(@folder_8)
    
    @folder_4.reload
    @folder_5.reload
    @folder_6.reload
    @folder_7.reload
    
    assert_equal 2, @folder_5.order_by
    assert_equal 3, @folder_6.order_by
    assert_equal 4, @folder_7.order_by
    assert_equal 5, @folder_4.order_by
  end
  
  def test_move_after_different_levels
    @folder_11.move_before(@folder_8)
    
    @folder_7.reload
    @folder_8.reload
    @folder_9.reload
    @folder_10.reload
    @folder_11.reload
    @folder_12.reload
    
    assert_equal 5, @folder_7.order_by
    assert_equal 6, @folder_11.order_by
    assert_equal 7, @folder_8.order_by
    assert_equal 8, @folder_9.order_by
    
    assert_equal 1, @folder_10.order_by
    assert_equal 2, @folder_12.order_by
  end
  
  def test_move_as_child_of_empty_folder
    @folder_11.move_as_child_of(@folder_8)
    
    @folder_10.reload
    @folder_11.reload
    @folder_12.reload    
    
    assert_equal 1, @folder_11.order_by
    assert_equal @folder_8.id, @folder_11.parent_id
    
    assert_equal 1, @folder_10.order_by
    assert_equal 2, @folder_12.order_by
  end
  
  def test_move_as_child_of_non_empty_folder
    @folder_11.move_as_child_of(@folder_1)
    
    @folder_10.reload
    @folder_11.reload
    @folder_12.reload    
    
    assert_equal 8, @folder_11.order_by
    assert_equal @folder_1.id, @folder_11.parent_id
    
    assert_equal 1, @folder_10.order_by
    assert_equal 2, @folder_12.order_by
  end
end 