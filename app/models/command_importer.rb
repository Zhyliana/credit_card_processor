class CommandImporter
  def self.run
    if ARGV.empty?
      commands = []
      summary = "No transactions. Goodbye! \n"
      puts "Type ':wq' to save and exit"

      until (input = STDIN.gets.chomp).downcase == ":wq"
        commands << input
      end

      if commands.count >= 1
        summary = CommandProcessor.new.import(commands).summary_string
      end
    else
      file = File.open(ARGV.first)
      summary = CommandProcessor.new.import(file.read.split("\n")).summary_string
    end

    puts "-----TRANSACTION SUMMARY----------\n"
    puts summary
    puts "----------------------------------\n"
  end
end
