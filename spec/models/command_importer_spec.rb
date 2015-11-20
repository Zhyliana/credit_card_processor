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

  context "when ARGV is empty" do
    before do
      stub_const("ARGV", [])
    end
    
    it "prints summary of transactions" do
      expect(CommandImporter).to receive(:puts).with("Type ':wq' to save and exit")
      sample_transactions.each do |transaction|
        expect(STDIN).to receive(:gets) { transaction }
      end
      expect(CommandImporter).to receive(:puts).with("-----TRANSACTION SUMMARY----------\n")
      expect(CommandImporter).to receive(:puts).with("Lisa: $-93\nQuincy: error\nTom: $500\n")
      expect(CommandImporter).to receive(:puts).with("----------------------------------\n")

      CommandImporter.run
    end
    
    it "notifies when no transactions are entered" do
      expect(CommandImporter).to receive(:puts).with("Type ':wq' to save and exit")
      expect(STDIN).to receive(:gets) { ":wq" }
      expect(CommandImporter).to receive(:puts).with("-----TRANSACTION SUMMARY----------\n")
      expect(CommandImporter).to receive(:puts).with("No transactions. Goodbye! \n")
      expect(CommandImporter).to receive(:puts).with("----------------------------------\n")

      CommandImporter.run
    end
  end

  context "when ARGV is a filepath" do
    before do
      stub_const("ARGV", ["./example_input.txt"])
    end

    it "prints summary of transactions" do
      expect(CommandImporter).to receive(:puts).with("-----TRANSACTION SUMMARY----------\n")
      expect(CommandImporter).to receive(:puts).with("Lisa: $-93\nQuincy: error\nTom: $500\n")
      expect(CommandImporter).to receive(:puts).with("----------------------------------\n")

      CommandImporter.run
    end
  end
end