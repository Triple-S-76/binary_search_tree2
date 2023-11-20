require_relative '../main'
require 'pry-byebug'

describe Node do
  let(:my_node) { Node.new(123) }
  it 'tests initialize in the Node class' do
    expect(my_node.data).to eq(123)
    expect(my_node.left).to be_nil
    expect(my_node.right).to be_nil
  end
end

describe Tree do
  context 'Basic tests' do
    before(:each) { @my_tree = Tree.new }

    it 'tests initialize in Tree class' do
      expect(@my_tree.root).to be_nil
    end

    it 'tests the #build_tree method' do
      array = [5, 3, 3, 5, 1, 1]
      @my_tree.build_tree(array)

      expect(@my_tree.root.data).to eq(3)
      expect(@my_tree.root.left.data).to eq(1)
      expect(@my_tree.root.right.data).to eq(5)
    end
  end

  context 'Inserting nodes' do

    before(:each) do
      @my_tree = Tree.new
      array = [20, 30, 40, 50, 60, 70, 80]
      @my_tree.build_tree(array)
    end

    it 'inserts a node higher than all nodes' do
      @my_tree.insert(90)
      expect(@my_tree.root.right.right.right.data).to eq(90)
    end

    it 'inserts a node lower than all nodes' do
      @my_tree.insert(10)
      expect(@my_tree.root.left.left.left.data).to eq(10)
    end

    it 'inserts a node in the middle of the tree' do
      @my_tree.insert(65)
      expect(@my_tree.root.right.left.right.data).to eq(65)
    end
  end
end