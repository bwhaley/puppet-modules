module MCollective
  module Agent
    class Cassandra_cli<RPC::Agent
      action 'loadfile' do
        validate :filename, :shellsafe 
        run_cli 'loadfile', request[:filename]
      end

      private
      def run_cli(action,actionarg=nil)
        output = ''
        filename=actionarg
        reply.fail! "Cannot find #{filename}!" unless File.exist?(filename)
        # path to cassandra-cli may need to be updated
        reply.fail! "Cannot find /opt/apache-cassandra/bin/cassandra-cli!" unless File.exist?('/opt/apache-cassandra/bin/cassandra-cli')
        cmd = ['/opt/apache-cassandra/bin/cassandra-cli','-h','localhost']
        case action
        when 'loadfile'
          cmd << '-f' << actionarg
        end
        reply[:status] = run(cmd, :stdout => :output)
      end
    end
  end
end
