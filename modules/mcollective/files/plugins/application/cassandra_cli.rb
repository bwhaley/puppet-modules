class MCollective::Application::Cassandra_cli<MCollective::Application
    description "Load cassandra-cli statements a file"

    usage <<-END_OF_USAGE
mco cassandra_cli [OPTIONS] [FILTERS] loadfile <filename>

The <filename> should be the fully qualified path to a file containing cassandra-cli statements. The file must already exist on the node.
    END_OF_USAGE

  def post_option_parser(configuration)
    if ARGV.length < 1
      raise "Please specify filename"
      docs
    else
      configuration[:command] = ARGV.shift
      case configuration[:command]
      when 'loadfile'
        configuration[:filename] = ARGV.shift || docs
      end
    end
  end

  def docs
    puts "Usage: #{$0} <cmd>"
    puts "Available commands:"
    puts "  loadfile <filename>          - load statements from the specified file"
  end

  def main
    mc = rpcclient("cassandra_cli", :chomp => true)
    options = {:filename => configuration[:filename]} if configuration[:command] == 'loadfile'
    mc.send(configuration[:command], options).each do |resp|
      puts "#{resp[:sender]}:"
      if resp[:statuscode] == 0
        puts resp[:data][:output]
      else
        puts resp[:statusmsg]
      end
    end
    mc.disconnect
    printrpcstats
  end

end
