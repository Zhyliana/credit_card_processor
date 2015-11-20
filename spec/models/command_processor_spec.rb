describe CommandProcessor do
  let(:sample_transactions) {[
      "Add Tom 4111111111111111 $1000\n",
      "Add Lisa 5454545454545454 $3000\n",
      "Add Quincy 1234567890123456 $2000\n",
      "Charge Tom $500\n",
      "Charge Tom $800\n",
      "Charge Lisa $7\n",
      "Credit Lisa $100\n",
      "Credit Quincy $200\n",
  ]}

  let(:expected_summary) { "Lisa: $-93\nQuincy: error\nTom: $500\n" }

  describe ".import" do
    it 'processes an array of transactions' do
      expect(CommandProcessor.new.import(sample_transactions).summary_string).to eq(expected_summary)end
  end
end