describe CommandImporter do
  let(:sample_transactions) {[
      "Add Tom 4111111111111111 $1000\n",
      "Add Lisa 5454545454545454 $3000\n",
      "Add Quincy 1234567890123456 $2000\n",
      "Charge Tom $500\n",
      "Charge Tom $800\n",
      "Charge Lisa $7\n",
      "Credit Lisa $100\n",
      "Credit Quincy $200\n",
      ":wq"
  ]}

  let(:expected_summary) {
      "Lisa: $-93\n" +
      "Quincy: error\n" +
      "Tom: $500\n"
  }

  after do
    CommandImporter.run
  end

  def expect_output(stdout)
    expect(CommandImporter).to receive(:puts).with("-----TRANSACTION SUMMARY----------\n")
    expect(CommandImporter).to receive(:puts).with(stdout)
    expect(CommandImporter).to receive(:puts).with("----------------------------------\n")
  end

  context "when ARGV is empty" do
    before do
      stub_const("ARGV", [])
      expect(CommandImporter).to receive(:puts).with("Type ':wq' to save and exit")
    end
    
    it "prints summary of transactions" do
      sample_transactions.each do |transaction|
        expect(STDIN).to receive(:gets) { transaction }
      end

      expect_output(expected_summary)
    end
    
    it "notifies when no transactions are entered" do
      expect(STDIN).to receive(:gets) { ":wq" }
      expect_output("No transactions. Goodbye! \n")
    end
  end

  context "when ARGV is a filepath" do
    before do
      stub_const("ARGV", ["./example_input.txt"])
    end

    it "prints summary of transactions" do
      expect_output(expected_summary)
    end
  end
end