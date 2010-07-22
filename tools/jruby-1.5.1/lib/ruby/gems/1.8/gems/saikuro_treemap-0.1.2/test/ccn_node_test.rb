require 'test_helper'

class CCNNodeTest < Test::Unit::TestCase
  include SaikuroTreemap
  
  def test_to_json_for_single_node
    assert_equal '{"name":"A","data":{},"id":"A","children":[]}', CCNNode.new('A').to_json
  end
  
  def test_to_json_for_node_with_children
    root = CCNNode.new('A')
    root.add_child CCNNode.new('A::B')
    assert_equal '{"name":"A","data":{},"id":"A","children":[{"name":"B","data":{},"id":"A::B","children":[]}]}', root.to_json
  end
  
  def test_to_json_for_method_node
    assert_equal '{"name":"abc","data":{},"id":"A#abc","children":[]}', CCNNode.new('A#abc').to_json  
  end
  
  def test_to_json_for_root_node
    assert_equal '{"name":"","data":{},"id":"","children":[]}', CCNNode.new('').to_json  
  end
  
  def test_to_json_include_complicity_and_lines
    node = CCNNode.new('A', 2, 30)
    node_json = JSON.parse(node.to_json)
    assert_equal 2, node_json['data']['complexity']
    assert_equal 30, node_json['data']['lines']
    assert_equal node.area, node_json['data']['$area']
    assert_equal node.color, node_json['data']['$color']
  end
  
  def test_find_node_without_param_should_return_it_self
    node = CCNNode.new('A::B::C')
    assert_equal node, node.find_node()
  end
  
  def test_find_node_should_find_it_self_it_path_match
    node = CCNNode.new('A::B::C')
    assert_equal node, node.find_node('A', 'B', 'C')
    assert_equal nil, node.find_node('A', 'B')
  end
  
  def test_find_node_should_find_matching_child_node
    parent = CCNNode.new('A')
    child = CCNNode.new('A::B::C')
    parent.add_child child
    
    assert_equal child, parent.find_node('A', 'B', 'C')
    assert_equal nil, parent.find_node('A', 'B')
  end
  
  def test_create_nodes
    node = CCNNode.new('A')
    node.create_nodes('A', 'B', 'C', 'D')
    assert_equal 'A::B', node.find_node('A', 'B').path
    assert_equal 'A::B::C', node.find_node('A', 'B', 'C').path
    assert_equal 'A::B::C::D', node.find_node('A', 'B', 'C', 'D').path
  end
  
  def test_node_should_be_red_when_code_is_ridiculous
    assert_equal "#AE0000", CCNNode.new('A', 15).color
    assert_equal "#AE0000", CCNNode.new('A', 10).color
  end
  
  def test_node_should_be_blue_when_code_should_be_noticed
    assert_equal "#4545C2", CCNNode.new('A', 5).color
    assert_equal "#4545C2", CCNNode.new('A', 9).color
  end
  
  def test_node_should_be_green_if_code_is_ok
    assert_equal "#006500", CCNNode.new('A', 1).color
    assert_equal "#006500", CCNNode.new('A', 4).color
  end
  
  def test_none_left_node_color_is_consistent_dark
    parent = CCNNode.new('A', 10)
    parent.add_child CCNNode.new('A::B::C')
    
    assert_equal "#101010", parent.color
  end
  
  def test_area_is_same_with_lines_for_leaf_node
    assert_equal 30, CCNNode.new('A', 10, 30).area
  end
  
  def test_area_is_sum_of_child_node_area_for_non_leaf_node
    parent = CCNNode.new('A', 10, 10)
    parent.add_child CCNNode.new('A::B::C', 10, 20)
    parent.add_child CCNNode.new('A::B::C', 10, 30)
    
    assert_equal 50, parent.area
  end
  
  
end