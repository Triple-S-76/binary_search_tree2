require_relative '../main'

describe Node do
  let(:my_node) { Node.new(123) }
  it 'tests the node class' do
    my_node.data = 123
    expect(my_node.data).to eq(123)
    expect(my_node.left).to be_nil
    expect(my_node.right).to be_nil
  end
end
