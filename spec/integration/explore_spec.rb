RSpec.describe "`accounting explore` command", type: :cli do
  it "executes `exe/accounting help explore` command successfully" do
    output = `exe/accounting help explore`
    expected_output = <<-OUT
Usage:
  accounting explore [QUERY]

Options:
  -h, [--help], [--no-help]            # Display usage information
  -d, [--details], [--no-details]      # Display more information about the expenses
  -f, [--files-pattern=FILES_PATTERN]  # Regular expression to find CSV files. Defaults to "./priv/*.csv"

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
