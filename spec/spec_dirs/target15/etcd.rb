describe ("check etcd config") do
  describe file("/etc/etcd/etcd.conf") do
    its(:content) { should match /^#{ Regexp.escape("ETCD_LISTEN_CLIENT_URLS=\"http://0.0.0.0:2379\"")}$/ }
    its(:content) { should match /^#{ Regexp.escape("ETCD_ADVERTISE_CLIENT_URLS=\"http://0.0.0.0:2379\"")}$/ }
  end
end

describe ("check etcd service is started and enabled") do
  describe service("etcd") do
    it { should be_running }
    it { should be_enabled }
  end
end

describe ("check etcd management dir is created") do
  describe command("etcdctl ls -r") do
    its(:stdout) { should match /^\/kube-centos\/network$/ }
  end
end

describe ("check etcd key is created") do
  describe command("etcdctl get /kube-centos/network/config") do
    its(:exit_status) { should eq 0 }
  end
end
