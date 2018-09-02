require 'accounting/commands/explore'

RSpec.describe Accounting::Commands::Explore do
  it "executes `explore` command successfully" do
    output = StringIO.new
    query = nil
    options = {}
    command = Accounting::Commands::Explore.new(query, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
