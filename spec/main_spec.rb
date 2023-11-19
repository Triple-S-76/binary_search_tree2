require_relative '../main'

describe Node do
  let(:my_node) { Node.new(123) }
  it 'tests initialize in the Node class' do
    expect(my_node.data).to eq(123)
    expect(my_node.left).to be_nil
    expect(my_node.right).to be_nil
  end
end

describe Tree do
  let(:my_tree) { Tree.new([1, 2, 3]) }

  it 'tests initialize in Tree class' do
    expect(my_tree.array).to eq([1, 2, 3])
  end
end