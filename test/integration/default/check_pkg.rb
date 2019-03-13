describe command('which consul') do
  its('stdout') { should eq "/usr/local/bin/consul\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end
