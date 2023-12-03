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
      expect(@my_tree.root.left.left).to be_nil
      expect(@my_tree.root.left.right).to be_nil
      expect(@my_tree.root.right.left).to be_nil
      expect(@my_tree.root.right.right).to be_nil
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

  context 'Deleting Nodes' do
    before(:each) do
      @my_tree = Tree.new
      array = [20, 30, 40, 50, 60, 70, 80]
      @my_tree.build_tree(array)
    end

    it '#delete - Attempts to delete a node in an empty tree' do
      @my_empty_tree = Tree.new
      error = @my_empty_tree.delete(123)
      expect(error).to eq('The tree is empty')
    end

    it '#delete - sends message to delete root node' do
      my_root_node_tree = Tree.new
      array = [10, 20, 30]
      my_root_node_tree.build_tree(array)
      expect(my_root_node_tree.root.data).to eq(20)
      expect(my_root_node_tree).to receive(:delete_root_node).once
      my_root_node_tree.delete(20)
    end

    it '#delete_root_node - deletes the root node with no children' do
      my_tree_with_only_root = Tree.new
      my_tree_with_only_root.build_tree([99])
      expect(my_tree_with_only_root.root.data).to eq(99)
      expect(my_tree_with_only_root.root.left).to be_nil
      expect(my_tree_with_only_root.root.right).to be_nil
      my_tree_with_only_root.delete(99)
      expect(my_tree_with_only_root.root).to be_nil
    end

    it '#delete_root_node - with left child only' do
      my_tree = Tree.new
      my_tree.build_tree([20])
      my_tree.insert(10)
      expect(my_tree.root.data).to eq(20)
      expect(my_tree.root.left.data).to eq(10)
      my_tree.delete(20)
      expect(my_tree.root.data).to eq(10)
    end

    it '#delete_root_node - with right child only' do
      my_tree = Tree.new
      my_tree.build_tree([10, 20])
      expect(my_tree.root.data).to eq(10)
      expect(my_tree.root.right.data).to eq(20)
      my_tree.delete(10)
      expect(my_tree.root.data).to eq(20)
    end

    it '#delete_root_node - with 2 children - right child is leaf node' do
      my_tree = Tree.new
      my_tree.build_tree([10, 20, 30])
      expect(my_tree.root.data).to eq(20)
      expect(my_tree.root.left.data).to eq(10)
      expect(my_tree.root.right.data).to eq(30)
      my_tree.delete_root_node
      expect(my_tree.root.data).to eq(30)
      expect(my_tree.root.left.data).to eq(10)
      expect(my_tree.root.right).to be_nil
    end

    it '#delete_root_node - with 2 children - both sides have many children' do
      my_tree = Tree.new
      array = [0]
      50.times { array << array[-1] + 1 }
      my_tree.build_tree(array)
      expect(my_tree.root.data).to eq(25)
      expect(my_tree.root.left.data).to eq(12)
      expect(my_tree.root.right.data).to eq(38)
      my_tree.delete_root_node
      expect(my_tree.root.data).to eq(26)
      expect(my_tree.root.left.data).to eq(12)
      expect(my_tree.root.right.data).to eq(38)
      expect(my_tree.root.right.left.left.left.data).to eq(27)
    end

    it '#delete_root_node - with 2 children - both sides have many children' do
      my_tree = Tree.new
      array = [0]
      200.times { array << array[-1] + 1 }
      my_tree.build_tree(array)
      expect(my_tree.root.data).to eq(100)
      expect(my_tree.root.left.data).to eq(49)
      expect(my_tree.root.right.data).to eq(150)
      my_tree.delete_root_node
      expect(my_tree.root.data).to eq(101)
      expect(my_tree.root.left.data).to eq(49)
      expect(my_tree.root.right.data).to eq(150)
      expect(my_tree.root.right.left.left.left.left.left.data).to eq(102)
    end

    it 'Deletes node with no children' do
      expect(@my_tree).to receive(:delete_node).with(60).once
      @my_tree.delete(60)
    end

    it '#node_children_info - sends left when data is lower' do
      test_node = @my_tree.root.right
      expect(@my_tree).to receive(:get_children_info).with(test_node.left).once
      @my_tree.node_children_info(60, test_node)
    end

    it '#node_children_info - sends left when data is higher' do
      test_node = @my_tree.root.right
      expect(@my_tree).to receive(:get_children_info).with(test_node.right).once
      @my_tree.node_children_info(80, test_node)
    end

    it '#get_children_info - returns "leaf" when node is leaf node' do
      node_instance_double = instance_double(Node)
      allow(node_instance_double).to receive_message_chain(:left, :nil?).and_return(true)
      allow(node_instance_double).to receive_message_chain(:right, :nil?).and_return(true)
      child_info = @my_tree.get_children_info(node_instance_double)
      expect(child_info).to eq('leaf')
    end

    it '#get_children_info - returns "left child" when node has a left child' do
      node_instance_double = instance_double(Node)
      allow(node_instance_double).to receive(:left).and_return(false, false)
      allow(node_instance_double).to receive_message_chain(:right, :nil?).and_return(true)
      child_info = @my_tree.get_children_info(node_instance_double)
      expect(child_info).to eq('left child')
    end

    it '#get_children_info - returns "right child" when node has a right child' do
      node_instance_double = instance_double(Node)
      allow(node_instance_double).to receive_message_chain(:left, :nil?).and_return(true)
      allow(node_instance_double).to receive_message_chain(:right, :nil?).and_return(false)
      child_info = @my_tree.get_children_info(node_instance_double)
      expect(child_info).to eq('right child')
    end

    it '#get_children_info - returns "2 children" when node has 2 children' do
      node_instance_double = instance_double(Node)
      allow(node_instance_double).to receive_message_chain(:left, :nil?).and_return(false)
      allow(node_instance_double).to receive_message_chain(:right, :nil?).and_return(false)
      child_info = @my_tree.get_children_info(node_instance_double)
      expect(child_info).to eq('2 children')
    end

    it '#delete_node - make sure remove_node is sending correct data' do
      parent_node_double = double(Node)
      allow(@my_tree).to receive(:find_parent_node).and_return(parent_node_double)
      allow(@my_tree).to receive(:node_children_info).and_return('leaf')
      expect(@my_tree).to receive(:remove_node).with(parent_node_double, 'leaf', 123).once
      @my_tree.delete_node(123)
    end

    context '#remove_node - correct message sent in each case' do
      before(:each) { @parent_node_double = double(Node) }

      it '#remove_node - send message: remove_leaf_node(parent_node)' do
        expect(subject).to receive(:remove_leaf_node)
        subject.remove_node(@parent_node_double, 'leaf')
      end

      it '#remove_node - send message: remove_node_with_left_child(parent_node)' do
        expect(subject).to receive(:remove_node_with_left_child)
        subject.remove_node(@parent_node_double, 'left child')
      end

      it '#remove_node - send message: remove_node_with_right_child(parent_node)' do
        expect(subject).to receive(:remove_node_with_right_child)
        subject.remove_node(@parent_node_double, 'right child')
      end

      it '#remove_node - send message: remove_node_with_2_children(parent_node)' do
        expect(subject).to receive(:remove_node_with_2_children)
        subject.remove_node(@parent_node_double, '2 children')
      end
    end

    context 'removing different nodes with different children' do
      before(:each) do
        @my_tree = Tree.new
        array = [20, 30, 40, 50, 60, 70, 80]
        @my_tree.build_tree(array)
        @my_tree.insert(15)
        @my_tree.insert(45)
        @my_tree.insert(65)
        @my_tree.insert(75)
      end

      it '#remove_leaf_node - left side' do
        parent_node = @my_tree.root.left.left
        expect(parent_node.data).to eq(20)
        node_to_delete = parent_node.left
        expect(node_to_delete.data).to eq(15)
        data = node_to_delete.data
        expect(data).to eq(15)
        @my_tree.remove_leaf_node(parent_node, data)
        expect(parent_node.left).to be_nil
        expect(parent_node.right).to be_nil
      end

      it '#remove_leaf_node - right side' do
        parent_node = @my_tree.root.left.right
        expect(parent_node.data).to eq(40)
        node_to_delete = parent_node.right
        expect(node_to_delete.data).to eq(45)
        data = node_to_delete.data
        expect(data).to eq(45)
        @my_tree.remove_leaf_node(parent_node, data)
        expect(parent_node.left).to be_nil
        expect(parent_node.right).to be_nil
      end

      it '#remove_node_with_left_child - node to delete is left of parent' do
        parent_node = @my_tree.root.left
        expect(parent_node.data).to eq(30)
        node_to_delete = parent_node.left
        expect(node_to_delete.data).to eq(20)
        expect(node_to_delete.left.data).to eq(15)
        expect(node_to_delete.right).to be_nil
        @my_tree.remove_node_with_left_child(parent_node, 20)
        expect(parent_node.left.data).to eq(15)
      end

      it '#remove_node_with_left_child - node to delete is right of parent' do
        parent_node = @my_tree.root.right
        expect(parent_node.data).to eq(70)
        node_to_delete = parent_node.right
        expect(node_to_delete.data).to eq(80)
        expect(node_to_delete.left.data).to eq(75)
        expect(node_to_delete.right).to be_nil
        @my_tree.remove_node_with_left_child(parent_node, 80)
        expect(parent_node.right.data).to eq(75)
      end

      it '#remove_node_with_right_child - node to delete is left of parent' do
        parent_node = @my_tree.root.right
        expect(parent_node.data).to eq(70)
        node_to_delete = parent_node.left
        expect(node_to_delete.data).to eq(60)
        expect(node_to_delete.left).to be_nil
        expect(node_to_delete.right.data).to eq(65)
        @my_tree.remove_node_with_right_child(parent_node, 60)
        expect(parent_node.left.data).to eq(65)
        expect(parent_node.left.right).to be_nil
        expect(parent_node.left.left).to be_nil
      end

      it '#remove_node_with_right_child - node to delete is right of parent' do
        parent_node = @my_tree.root.left
        expect(parent_node.data).to eq(30)
        node_to_delete = parent_node.right
        expect(node_to_delete.data).to eq(40)
        expect(node_to_delete.left).to be_nil
        expect(node_to_delete.right.data).to eq(45)
        @my_tree.remove_node_with_right_child(parent_node, 40)
        expect(parent_node.right.data).to eq(45)
        expect(parent_node.right.left).to be_nil
        expect(parent_node.right.right).to be_nil
      end
    end

    context 'removing nodes with 2 children' do
      before(:each) do
        @my_tree = Tree.new
        array = [20, 30, 40, 50, 60, 70, 80]
        @my_tree.build_tree(array)
        @my_tree.insert(15)
        @my_tree.insert(45)
        @my_tree.insert(65)
        @my_tree.insert(75)
        @my_tree.insert(35)
        @my_tree.insert(34)
        @my_tree.insert(36)
        @my_tree.insert(43)
        @my_tree.insert(44)
        @my_tree.insert(42)
        @my_tree.insert(42.5)
        @my_tree.insert(41)
      end

      it '#remove_node_with_2_children - node to move has no children' do
        parent_node = @my_tree.root.left
        expect(parent_node.data).to eq(30)
        node_to_delete = parent_node.right
        expect(node_to_delete.data).to eq(40)
        expect(node_to_delete.left.data).to eq(35)
        expect(node_to_delete.right.data).to eq(45)
        @my_tree.remove_node_with_2_children(parent_node, 40)
        expect(parent_node.right.data).to eq(41)
      end

      it '#remove_node_with_2_children - node to move has a right child' do
        @my_tree.insert(41.5)
        parent_node = @my_tree.root.left
        expect(parent_node.data).to eq(30)
        node_to_delete = parent_node.right
        expect(node_to_delete.data).to eq(40)
        expect(node_to_delete.left.data).to eq(35)
        expect(node_to_delete.right.data).to eq(45)
        @my_tree.remove_node_with_2_children(parent_node, 40)
        expect(parent_node.right.data).to eq(41)
      end

      it '#remove_node_with_2_children - node to move is node to removes right child' do
        parent_node = @my_tree.root.left.right.right.left
        expect(parent_node.data).to eq(43)
        node_to_delete = parent_node.left
        expect(node_to_delete.data).to eq(42)
        expect(node_to_delete.left.data).to eq(41)
        expect(node_to_delete.right.data).to eq(42.5)
        @my_tree.remove_node_with_2_children(parent_node, 42)
      end
    end

  end
  context 'misc tests' do
    it '#find_parent_node - finds parent node' do
      my_tree = Tree.new
      array = [20, 30, 40, 50, 60, 70, 80]
      my_tree.build_tree(array)
      parent_node30 = my_tree.find_parent_node(20)
      expect(parent_node30.data).to eq(30)

      parent_node50 = my_tree.find_parent_node(70)
      expect(parent_node50.data).to eq(50)
    end

    it '#find - returns node when node with data exists' do
      my_tree = Tree.new
      array = [0]
      100.times { array << array[-1] + 1 }
      my_tree.build_tree(array)
      node = my_tree.find(33)
      expect(node.data).to eq(33)
    end

    it '#height - returns an integer of the number of edges to the furthest leaf node' do
      my_tree = Tree.new
      array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
      my_tree.build_tree(array)
      height = my_tree.height
      expect(height).to eq(3)
    end

    context '#depth' do
      it '#depth - returns an integer of the number of edges from a node up to the root' do
        my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        my_tree.build_tree(array)
        depth = my_tree.depth(90)
        expect(depth).to eq(2)
      end

      it '#depth - returns an integer of the number of edges from a node up to the root' do
        my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        my_tree.build_tree(array)
        depth = my_tree.depth(50)
        expect(depth).to eq(0)
      end

      it '#depth - returns an integer of the number of edges from a node up to the root' do
        my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        my_tree.build_tree(array)
        depth = my_tree.depth(100)
        expect(depth).to eq(3)
      end

      it '#depth - returns -1 when the data value does not exist in the tree' do
        my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        my_tree.build_tree(array)
        depth = my_tree.depth(10000)
        expect(depth).to eq(-1)
      end
    end

    context 'Tree traversal' do
      before(:each) do
        @my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        @my_tree.build_tree(array)
      end

      it '#level_order - returns an array with all items in the tree in level order' do
        level_order = @my_tree.level_order
        expect(level_order).to eq([50, 20, 80, 10, 30, 60, 90, 40, 70, 100])
      end

      it '#level_order_recursive - returns an array with all items in the tree in level order' do
        level_order = @my_tree.level_order_recursive
        expect(level_order).to eq([50, 20, 80, 10, 30, 60, 90, 40, 70, 100])
      end

      it '#inorder - returns an array with all items inorder' do
        inorder = @my_tree.inorder
        expect(inorder).to eq([10, 20, 30, 40, 50, 60, 70, 80, 90, 100])
      end

      it '#preorder - returns an array with all items in inorder' do
        preorder = @my_tree.preorder
        expect(preorder).to eq([50, 20, 10, 30, 40, 80, 60, 70, 90, 100])
      end

      it '#postorder - returns an array with all items in postorder' do
        postorder = @my_tree.postorder
        expect(postorder).to eq([10, 40, 30, 20, 70, 60, 100, 90, 80, 50])
      end
    end

    context 'Checks if the tree is balanced?' do
      before(:each) do
        @my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        @my_tree.build_tree(array)
      end

      it '#balanced? - This tree is balanced' do
        result = @my_tree.balanced?
        expect(result).to be true
      end

      it '#balanced? - This tree is not balanced' do
        @my_tree.insert(1000)
        @my_tree.insert(2000)
        @my_tree.insert(3000)
        @my_tree.insert(4000)
        @my_tree.insert(5000)
        result = @my_tree.balanced?
        expect(result).to be false
      end

      it '#balanced? - This tree is not balanced' do
        @my_tree.insert(1)
        @my_tree.insert(2)
        @my_tree.insert(3)
        @my_tree.insert(4)
        @my_tree.insert(5)
        result = @my_tree.balanced?
        expect(result).to be false
      end
    end

    context '#rebalance - Rebalances the tree when there is an unbalanced tree' do
      before(:each) do
        @my_tree = Tree.new
        array = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        @my_tree.build_tree(array)
      end

      it '#rebalance - Rebalances an unbalanced tree' do
        original_tree = @my_tree.balanced?
        expect(original_tree).to be true
        @my_tree.insert(1000)
        @my_tree.insert(2000)
        @my_tree.insert(3000)
        @my_tree.insert(4000)
        @my_tree.insert(5000)
        unbalanced_tree = @my_tree.balanced?
        expect(unbalanced_tree).to be false
        @my_tree.rebalance
        rebalanced_tree = @my_tree.balanced?
        expect(rebalanced_tree).to be true
      end

      it '#rebalance - Rebalances an unbalanced tree' do
        original_tree = @my_tree.balanced?
        expect(original_tree).to be true
        @my_tree.insert(1)
        @my_tree.insert(2)
        @my_tree.insert(3)
        @my_tree.insert(4)
        @my_tree.insert(5)
        unbalanced_tree = @my_tree.balanced?
        expect(unbalanced_tree).to be false
        @my_tree.rebalance
        rebalanced_tree = @my_tree.balanced?
        expect(rebalanced_tree).to be true
      end
    end
  end
end
