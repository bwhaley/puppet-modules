metadata :name        => "nodetool",
         :description => "Performs certain Cassandra nodetool operations",
         :author      => "Ben Whaley",
         :license     => "MIT",
         :version     => "1.01",
         :url         => "www.apigee.com",
         :timeout     => 1200

action 'snapshot', :description => "initiate snapshot of all keyspaces with name <name>" do
    input :snapname,
          :prompt      => "Name of snapshot",
          :description => "Take a snapshot of all keyspaces with the given name",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 20
  
  output :output,
         :description => "Output from nodetool snapshot",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool snapshot",
         :display_as  => "Return Status"
end

action 'clearsnapshot', :description => "Remove all snapshots" do
  output :output,
         :description => "Output from nodetool clearsnapshot",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool clearsnapshot",
         :display_as  => "Return Status"
end

action 'ring', :description => "Print informations on the token ring" do
  output :output,
         :description => "Output from nodetool ring ",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool ring",
         :display_as  => "Return Status"
end

action 'cfstats', :description => "Print statistics on column families" do
  output :output,
         :description => "Output from nodetool cfstats",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool cfstats",
         :display_as  => "Return Status"
end

action 'info', :description => "Print node informations (uptime, load, ...)" do
  output :output,
         :description => "Output from nodetool info",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool info",
         :display_as  => "Return Status"
end

action 'version', :description => "Print cassandra version" do
  output :output,
         :description => "Output from nodetool version",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool version",
         :display_as  => "Return Status"
end

action 'repair', :description => "Run a repair on a cassandra node" do
  output :output,
         :description => "Output from nodetool repair",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool repair",
         :display_as  => "Return Status"
end

action 'netstats', :description => "Print network information on provided host" do
  output :output,
         :description => "Output from nodetool netstats",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool netstats",
         :display_as  => "Return Status"
end

action 'compactionstats', :description => "Print statistics on compactions" do
  output :output,
         :description => "Output from nodetool compactionstats",
         :display_as  => "Output"

  output :status,
         :description => "Return status of nodetool compactionstats",
         :display_as  => "Return Status"
end

