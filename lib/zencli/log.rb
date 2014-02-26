module ZenCLI
  class Log

    class << self
      attr_accessor :logfile
      @logfile = File.join(Dir.pwd, ".zencli-log")

      def info(message, options={})
        output = ""
        output << "       " if options[:indent]
        output << "-----> " if !(options[:arrows] === false)
        output << message
        write(output)
        output = output.send(options[:color] || :cyan) unless options[:color] == false
        puts output
      end

      def write(message)
        File.open(@logfile, "a") do |f|
          f.write(message+"\n")
        end
      end
    end

  end
end
