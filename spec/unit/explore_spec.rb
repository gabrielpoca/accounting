require 'accounting/commands/explore'
require 'pastel'

RSpec.describe Accounting::Commands::Explore do
  describe "filters" do
    it "executes `explore` command successfully" do
      output = StringIO.new
      query = "month"
      options = {}
      command = Accounting::Commands::Explore.new(query, options)

      command.execute(output: output)

      expect(Pastel.new.strip(output.string)).to eq <<-RES
root
 June → €-755,00
 July → €-203,00
RES
    end

    it "filters by month" do
      output = StringIO.new
      query = "month"
      options = {}
      command = Accounting::Commands::Explore.new(query, options)

      command.execute(output: output)

      expect(Pastel.new.strip(output.string)).to eq <<-RES
root
 June → €-755,00
 July → €-203,00
RES
    end

    it "filters by category" do
      output = StringIO.new
      query = "category"
      options = {}
      command = Accounting::Commands::Explore.new(query, options)

      command.execute(output: output)

      expect(Pastel.new.strip(output.string)).to eq <<-RES
root
 groceries → €-220,00
 out → €-68,00
 farmacy → €-50,00
 other → €-120,00
 vacations → €-450,00
 home_expenses → €-50,00
RES
    end

    it "filters by month then weekday" do
      output = StringIO.new
      query = "month,weekday"
      options = {}
      command = Accounting::Commands::Explore.new(query, options)

      command.execute(output: output)

      expect(Pastel.new.strip(output.string)).to eq <<-RES
root
 June
   saturday → €-180,00
   friday → €-125,00
   wednesday → €-450,00
 July
   tuesday → €-50,00
   monday → €-108,00
   sunday → €-45,00
RES
    end

    it "filters by a specific category" do
      output = StringIO.new
      query = "category=vacations"
      options = {}
      command = Accounting::Commands::Explore.new(query, options)

      command.execute(output: output)

      expect(Pastel.new.strip(output.string)).to eq <<-RES
root
 vacations → €-450,00
RES
    end
  end

  describe "options" do
    it "displays the expenses that add up to a value" do
      output = StringIO.new
      query = "month=July"
      options = { details: true }
      command = Accounting::Commands::Explore.new(query, options)

      command.execute(output: output)

      expect(Pastel.new.strip(output.string)).to eq <<-RES
root
 July → €-203,00
  2018-07-31 €-50,00 → some gas
  2018-07-30 €-100,00 → more food
  2018-07-30 €-8,00 → kingdom of belga
  2018-07-29 €-15,00 → my medicine
  2018-07-29 €-30,00 → some other stuff
RES
    end
  end
end
