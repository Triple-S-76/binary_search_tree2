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

my_array = [5, 6, 6, 7, 4, 5, 5, 4, 5, 6, 6, 1, 2, 3, 4, 5, 6, 7]
my_tree = Tree.new
my_tree.build_tree(my_array)
3.times { puts }
my_tree.pretty_print
3.times { puts }
my_tree.insert(99)
my_tree.insert(-99)
my_tree.insert(5.5)
my_tree.pretty_print
3.times { puts }

