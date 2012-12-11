module MCollective
  module Agent
    class Nodetool<RPC::Agent
      action 'snapshot' do
        validate :snapname, :shellsafe 
        run_nodetool 'snapshot', request[:snapname]
      end
        [
          'clearsnapshot',
          'ring',
          'cfstats',
          'version',
          'repair',
          'info',
          'netstats'
        ].each do |act|
        action act do
          run_nodetool act
        end
      end

      private
      def run_nodetool(action,actionarg=nil)
        output = ''
        # path to nodetool may need to be updated
        cmd = ['/opt/apache-cassandra/bin/nodetool','-h','localhost']
        case action
        when 'snapshot'
          cmd << 'snapshot' << '-t' << actionarg
        else
          cmd << action
        end
        reply[:status] = run(cmd, :stdout => :output)
      end
    end
  end
end
