metadata :name        => "cassandra_cli",
         :description => "Load cassandra-cli statements from a file",
         :author      => "Ben Whaley",
         :license     => "MIT",
         :version     => "1.0",
         :url         => "www.apigee.com",
         :timeout     => 1200

action 'loadfile', :description => "load statements from the specified file" do
    input :filename,
          :prompt      => "Name of file to load",
          :description => "Fully qualified path to file containing cassandra-cli statements",
          :type        => :string,
          :validation  => '^/[/a-zA-Z\-_\d\.]+$',
          :optional    => false,
          :maxlength   => 30
  
  output :output,
         :description => "Output from cassandra-cli",
         :display_as  => "Output"

  output :status,
         :description => "Return status of cassandra-cli",
         :display_as  => "Return Status"
end

