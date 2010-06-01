require "test_helper"

class FHeapTest < ActiveSupport::TestCase
  def setup
    @heap = FHeap.new
  end
  
  def setup_sample_heap
    @node_1 = @heap.insert!(1)
    @node_2 = @heap.insert!(2)
    @node_6 = @heap.insert!(6)
    
    @node_5 = @node_2.add_child!(5)
    
    @node_3 = @node_1.add_child!(3)
    @node_4 = @node_1.add_child!(4)
    @node_7 = @node_1.add_child!(7)
    
    @node_8 = @node_7.add_child!(8)
    @node_9 = @node_8.add_child!(9)
    
    assert_equal 3, @heap.trees.length
    assert_equal 1, @heap.min_node.value
  end
  
  test "min_node with no trees" do
    assert_nil @heap.min_node
  end
  
  test "insert updates min_node" do
    @heap.insert!(1)
    assert_equal 1, @heap.min_node.value
    
    @heap.insert!(2)
    assert_equal 1, @heap.min_node.value
    
    @heap.insert!(0)
    assert_equal 0, @heap.min_node.value
  end
  
  test "extract minimum (nothing in the heap)" do
    assert_nil @heap.extract_minimum!
  end
  
  test "extract minimum (one item in heap)" do
    @heap.insert!(1)
    assert_equal 1, @heap.extract_minimum!.value
  end
  
  test "extract minimum (calling after extracting the last node)" do
    @heap.insert!(1)
    assert_equal 1, @heap.extract_minimum!.value
    assert_nil      @heap.extract_minimum!
  end
  
  test "extract minimum (restructures correctly)" do
    setup_sample_heap
    
    assert_equal 1, @heap.extract_minimum!.value
    
    assert_equal 2, @heap.min_node.value
    assert_equal ["(2 (5), (3 (6)))", "(4)", "(7 (8 (9)))"], @heap.to_s
    
    assert @node_2.root?
    assert @node_4.root?
    assert @node_7.root?
    
    assert_equal @node_2, @node_5.root
    assert_equal @node_2, @node_3.root
    assert_equal @node_2, @node_6.root
    
    assert_equal @node_7, @node_8.root
    assert_equal @node_7, @node_9.root
    
    assert_equal @node_2, @node_2.parent
    assert_equal @node_4, @node_4.parent
    assert_equal @node_7, @node_7.parent
    
    assert_equal @node_2, @node_5.parent
    assert_equal @node_2, @node_3.parent
    assert_equal @node_3, @node_6.parent
    
    assert_equal @node_7, @node_8.parent
    assert_equal @node_8, @node_9.parent
  end
  
  test "decrease value (can't set higher than the existing value)" do
    setup_sample_heap
    
    assert_raises ArgumentError do
      @heap.decrease_value!(@node_9, 100)
    end
  end
  
  test "decrease value (doesn't do anything if you don't change the value)" do
    setup_sample_heap
    
    structure = @heap.to_s
    @heap.decrease_value!(@node_9, @node_9.value)
    
    assert_equal structure, @heap.to_s
  end
  
  test "decrease value (restructures correctly)" do
    setup_sample_heap
    @node_4.marked = true
    @node_7.marked = true
    @node_8.marked = true
    
    @heap.decrease_value!(@node_0 = @node_9, 0)
    
    assert_equal 0, @heap.min_node.value
    assert_equal ["(1 (3), (4))", "(2 (5))", "(6)", "(0)", "(8)", "(7)"], @heap.to_s
    
    assert ((0..8).to_a - [4]).all? { |number| !instance_variable_get(:"@node_#{number}").marked }
    assert @node_4.marked
    
    assert @node_1.root?
    assert @node_2.root?
    assert @node_6.root?
    assert @node_0.root?
    assert @node_8.root?
    assert @node_7.root?
    
    assert_equal @node_1, @node_3.root
    assert_equal @node_1, @node_4.root
    
    assert_equal @node_2, @node_5.root
    
    assert_equal @node_1, @node_3.parent
    assert_equal @node_1, @node_4.parent
    
    assert_equal @node_2, @node_5.parent
  end
  
  test "delete" do
    setup_sample_heap
    
    assert_equal @node_9, @heap.delete(@node_9)
    
    assert_equal 1, @heap.min_node.value
    assert_equal ["(1 (3), (4), (7 (8)))", "(2 (5))", "(6)"], @heap.to_s
    
    assert ((1..9).to_a - [8]).all? { |number| !instance_variable_get(:"@node_#{number}").marked }
    assert @node_8.marked
    
    assert @node_1.root?
    assert @node_2.root?
    assert @node_6.root?
    
    assert_equal @node_1, @node_3.root
    assert_equal @node_1, @node_4.root
    assert_equal @node_1, @node_7.root
    assert_equal @node_1, @node_8.root
    
    assert_equal @node_2, @node_5.root
    
    assert_equal @node_1, @node_3.parent
    assert_equal @node_1, @node_4.parent
    assert_equal @node_1, @node_7.parent
    assert_equal @node_7, @node_8.parent
    
    assert_equal @node_2, @node_5.parent
  end
end