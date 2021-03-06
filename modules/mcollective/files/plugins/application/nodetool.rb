class MCollective::Application::Nodetool<MCollective::Application
  def post_option_parser(configuration)
    if ARGV.length >= 1
      configuration[:command] = ARGV.shift
      case configuration[:command]
      when 'snapshot'
        configuration[:snapname] = ARGV.shift || docs
      end
    else
      docs
    end
  end

  def docs
    puts "Usage: #{$0} <cmd>"
    puts "Available commands:"
    puts "  ring                   - Print informations on the token ring"
    puts "  info                   - Print node informations (uptime, load, ...)"
    puts "  drain                  - Drain the node (stop accepting writes and flush all column families)"
    puts "  disablegossip          - Disable gossip (effectively marking the node dead)"
    puts "  enablegossip           - Reenable gossip"
    puts "  disablethrift          - Disable thrift server"
    puts "  enablethrift           - Reenable thrift server"
    puts "  cfstats                - Print statistics on column families"
    puts "  compactionstats        - Print statistics on compactions"
    puts "  version                - Print cassandra version"
    puts "  netstats               - Print network information on provided host (connecting node by default)"
    puts "  snapshot <name>        - Take a snapshot with the given <name>"
    puts "  clearsnapshot          - Remove all snapshots"
    puts "  repair                 - Run repair on a node"
  end

  def main
    mc = rpcclient("nodetool", :chomp => true)
    options = {:snapname => configuration[:snapname]} if configuration[:command] == 'snapshot'
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
