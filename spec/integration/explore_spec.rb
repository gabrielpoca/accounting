RSpec.describe "`accounting explore` command", type: :cli do
  it "executes `accounting help explore` command successfully" do
    output = `accounting help explore`
    expected_output = <<-OUT
Usage:
  accounting explore [QUERY]

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
