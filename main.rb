require 'pry-byebug'

# Creates each individual node
class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

# Builds the binary search tree
class Tree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def build_tree(array)
    sorted_array = array.sort.uniq

    @root = build_tree_recursive(sorted_array)
  end

  def insert(data)
    @root = Node.new(data) if @root.nil?

    insert_recursive(data, @root)
  end

  def delete(data)
    if @root.nil?
      'The tree is empty'
    elsif @root.data == data
      delete_root_node
    else
      delete_node(data)
    end
  end

  def delete_root_node
    root_children = node_children_info(nil)
    case root_children
    when 'leaf'
      @root = nil
    when 'left child'
      @root = @root.left
    when 'right child'
      @root = @root.right
    else
      node_to_move = find_next_largest_node(@root)
      node_to_move_parent = find_parent_node(node_to_move.data)
      node_to_move_parent.left = node_to_move.right unless node_to_move == @root.right
      node_to_move.left = @root.left
      node_to_move.right = @root.right unless node_to_move == @root.right
      @root = node_to_move
    end
  end

  def delete_node(data)
    parent_node = find_parent_node(data)
    return parent_node if parent_node.instance_of?(String)

    node_children = node_children_info(data, parent_node)
    remove_node(parent_node, node_children, data)
  end

  def find_parent_node(data, subtree = @root, parent_node = nil)
    return parent_node if data == subtree.data

    if data < subtree.data
      return 'This is not in the tree' if subtree.left.nil?

      find_parent_node(data, subtree.left, subtree)
    else
      return 'This is not in the tree' if subtree.right.nil?

      find_parent_node(data, subtree.right, subtree)
    end
  end

  def node_children_info(data, parent_node = nil)
    return get_children_info(@root) if parent_node.nil?

    if data < parent_node.data
      get_children_info(parent_node.left)
    else
      get_children_info(parent_node.right)
    end
  end

  def get_children_info(node)
    if node.left.nil? && node.right.nil?
      'leaf'
    elsif !node.left.nil? && node.right.nil?
      'left child'
    elsif node.left.nil? && !node.right.nil?
      'right child'
    else
      '2 children'
    end
  end

  def remove_node(parent_node, node_children, data = nil)
    case node_children
    when 'leaf'
      remove_leaf_node(parent_node, data)
    when 'left child'
      remove_node_with_left_child(parent_node, data)
    when 'right child'
      remove_node_with_right_child(parent_node, data)
    else
      remove_node_with_2_children(parent_node, data)
    end
  end

  def remove_leaf_node(parent_node, data)
    if data < parent_node.data
      parent_node.left = nil
    else
      parent_node.right = nil
    end
  end

  def remove_node_with_left_child(parent_node, data)
    if data < parent_node.data
      parent_node.left = parent_node.left.left
    else
      parent_node.right = parent_node.right.left
    end
  end

  def remove_node_with_right_child(parent_node, data)
    if data < parent_node.data
      parent_node.left = parent_node.left.right
    else
      parent_node.right = parent_node.right.right
    end
  end

  def remove_node_with_2_children(parent_node, data)
    node_to_delete = data < parent_node.data ? parent_node.left : parent_node.right

    node_to_move = find_next_largest_node(node_to_delete)
    node_to_move_parent = find_parent_node(data, node_to_delete, node_to_delete)
    node_to_move_parent.left = node_to_move.right
    node_to_move.left = node_to_delete.left
    node_to_move.right = node_to_delete.right unless node_to_move == node_to_delete.right
    data < parent_node.data ? parent_node.left = node_to_move : parent_node.right = node_to_move
  end

  def find(data, node = @root)
    return node if data == node.data

    data < node.data ? find(data, node.left) : find(data, node.right)
  end

  def find_next_largest_node(node_to_delete)
    node_to_move = node_to_delete.right
    until node_to_move.left.nil?
      node_to_move = node_to_move.left
    end
    node_to_move
  end

  def level_order
    array = []
    queue = [@root]
    until queue.empty?
      current_node = queue.shift
      array << current_node.data
      queue << current_node.left unless current_node.left.nil?
      queue << current_node.right unless current_node.right.nil?
    end
    array
  end

  def level_order_recursive(array = [], queue = [@root])
    return array if queue.empty?

    current_node = queue.shift
    array << current_node.data
    queue << current_node.left unless current_node.left.nil?
    queue << current_node.right unless current_node.right.nil?
    level_order_recursive(array, queue)
  end

  def inorder(current_node = root, array = [])
    return if current_node.nil?

    inorder(current_node.left, array)
    array << current_node.data
    inorder(current_node.right, array)
    array
  end

  def preorder(current_node = root, array = [])
    return if current_node.nil?

    array << current_node.data
    preorder(current_node.left, array)
    preorder(current_node.right, array)
    array
  end

  def postorder(current_node = root, array = [])
    return if current_node.nil?

    postorder(current_node.left, array)
    postorder(current_node.right, array)
    array << current_node.data
    array
  end

  def height(current_node = root, current_height = -1, max_height = 0)
    return max_height if current_node.nil?

    current_height += 1

    max_height = current_height if current_height > max_height
    left_height = height(current_node.left, current_height, max_height)
    right_height = height(current_node.right, current_height, max_height)
    [left_height, right_height, max_height].max
  end

  def depth(data)
    current_node = @root
    depth = 0
    until current_node.nil? || current_node.data == data
      depth += 1
      current_node = if data < current_node.data
                       current_node.left
                     else
                       current_node.right
                     end
    end
    current_node.nil? ? -1 : depth
  end

  def balanced?(current_node = @root, current_height = -1, array = [])
    return if current_node.nil?

    current_height += 1
    if current_node.left.nil? && current_node.right.nil?
      array << current_height
    else
      balanced?(current_node.left, current_height, array)
      balanced?(current_node.right, current_height, array)
    end
    array.max - array.min <= 1
  end

  def rebalance
    new_array = inorder
    build_tree(new_array)
  end

  def pretty_print
    pretty_print_private
  end

  private

  def build_tree_recursive(array, start_index = 0, end_index = array.length - 1)
    return nil if start_index > end_index

    mid = (start_index + end_index) / 2

    new_node = Node.new(array[mid])
    new_node.left = build_tree_recursive(array, start_index, mid - 1)
    new_node.right = build_tree_recursive(array, mid + 1, end_index)

    new_node
  end

  def insert_recursive(data, tree)
    if data < tree.data
      return insert_data(data, tree, 'left') if tree.left.nil?

      insert_recursive(data, tree.left)
    elsif data > tree.data
      return insert_data(data, tree, 'right') if tree.right.nil?

      insert_recursive(data, tree.right)
    else
      puts 'This data is already in the tree'
    end
  end

  def insert_data(data, tree, side)
    new_node = Node.new(data)

    if side == 'left'
      tree.left = new_node
    else
      tree.right = new_node
    end
  end

  def pretty_print_private(node = @root, prefix = '', is_left = true)
    pretty_print_private(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print_private(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

starting_array = []
25.times do
  starting_array << rand(1..100)
end
p starting_array

my_tree = Tree.new
my_tree.build_tree(starting_array)
p my_tree.balanced?

p "Level order: #{my_tree.level_order}"
p "Level order recursive: #{my_tree.level_order_recursive}"
p "Preorder: #{my_tree.preorder}"
p "Inorder: #{my_tree.inorder}"
p "Postorder: #{my_tree.postorder}"

10.times do
  random_number_over_1000 = rand(1000..10000)
  my_tree.insert(random_number_over_1000)
end

p my_tree.balanced?
my_tree.rebalance
p my_tree.balanced?

p "Level order: #{my_tree.level_order}"
p "Level order recursive: #{my_tree.level_order_recursive}"
p "Preorder: #{my_tree.preorder}"
p "Inorder: #{my_tree.inorder}"
p "Postorder: #{my_tree.postorder}"
