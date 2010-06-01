require "test_helper"

class NodeTest < ActiveSupport::TestCase
  def setup
    @root_node = FHeap::Node.new(:value, :root)
  end
  
  test "root_node?" do
    assert @root_node.root?
    assert @root_node.root.root?
    assert @root_node.parent.root?
  end
  
  test "adding children" do
    @root_node.add_child!(1)
    @root_node.add_child!(2)
    
    assert @root_node.children.all? { |child| !child.root? }
    assert @root_node.children.all? { |child| child.root == @root_node }
    assert @root_node.children.all? { |child| child.parent == @root_node }
  end
  
  test "adding children to children" do
    child_node = @root_node.add_child!(1)
    child_node.add_child!(2)
    child_node.add_child!(3)

    assert child_node.children.all? { |child| !child.root? }
    assert child_node.children.all? { |child| child.root == @root_node }
    assert child_node.children.all? { |child| child.parent == child_node }
  end
  
  test "assigning new root (assigning the same root node, shouldn't do anything)" do
    @root_node.root = @root_node
    
    assert @root_node.root?
    assert @root_node.root.root?
    assert @root_node.parent.root?
  end
  
  test "assigning new root with children (multiple levels deep)" do
    child_1 = @root_node.add_child!(:value)
    child_2 = @root_node.add_child!(:value)
    
    [child_1, child_2].each do |child_node|
      child_node.add_child!(:value)
      child_node.add_child!(:value)
    end
    
    deep_child = child_1.children.first.add_child!(:value)
    
    @root_node.children.each { |child| child.root = child }
    
    assert @root_node.children.all? { |child| child.root? }
    assert @root_node.children.all? { |child| child.root == child }
    assert @root_node.children.all? { |child| child.parent == child }
    
    [child_1, child_2].each do |new_root|
      assert new_root.children.all? { |child| !child.root? }
      assert new_root.children.all? { |child| child.root == new_root }
      assert new_root.children.all? { |child| child.parent == new_root }
    end
    
    assert !deep_child.root?
    assert deep_child.root == child_1
    assert deep_child.parent == child_1.children.first
  end
  
  test "degree" do
    child_1 = @root_node.add_child!(:value)
    child_2 = @root_node.add_child!(:value)
    child_3 = child_1.add_child!(:value)
    
    assert_equal 2, @root_node.degree
    assert_equal 1, child_1.degree
    assert_equal 0, child_2.degree
    assert_equal 0, child_3.degree
  end
end