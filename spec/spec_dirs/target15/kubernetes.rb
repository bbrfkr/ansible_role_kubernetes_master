describe ("check kubernetes common setting") do
  describe file("/etc/kubernetes/config") do
    its(:content) { should match /^KUBE_ALLOW_PRIV="--allow-privileged=true"$/ }
    its(:content) { should match /^KUBE_MASTER="--master=http:\/\/k8s-master:8080"$/ }
  end
end

describe ("check certification and key for serviceaccount") do
  describe file("/etc/kubernetes/ssl/apiserver.key") do
    it { should be_file }
  end

  describe file("/etc/kubernetes/ssl/apiserver.crt") do
    it { should be_file }
  end
end

describe ("check kubernetes api server setting") do
  describe file("/etc/kubernetes/apiserver") do
    its(:content) { should match /^#{ Regexp.escape("KUBE_API_ADDRESS=\"--address=0.0.0.0\"") }$/ }
    its(:content) { should match /^KUBE_API_PORT="--port=8080"$/ }
    its(:content) { should match /^KUBELET_PORT="--kubelet-port=10250"$/ }
    its(:content) { should match /^#{ Regexp.escape("KUBE_ETCD_SERVERS=\"--etcd-servers=http://k8s-master:2379\"") }$/ }
    its(:content) { should match /^#{ Regexp.escape("KUBE_SERVICE_ADDRESSES=\"--service-cluster-ip-range=10.254.0.0/19\"") }$/ }
    its(:content) { should match /^KUBE_API_ARGS="--service_account_key_file=\/etc\/kubernetes\/ssl\/apiserver.key"$/ }
  end
end

describe ("check certification and key are set to controller-manager") do
  describe file("/etc/kubernetes/controller-manager") do
    its(:content) { should match /^KUBE_CONTROLLER_MANAGER_ARGS="--root-ca-file=\/etc\/kubernetes\/ssl\/apiserver.crt --service_account_private_key_file=\/etc\/kubernetes\/ssl\/apiserver.key"$/ }
  end
end

describe ("check services are started and enabled") do
  services = ["kube-apiserver", "kube-controller-manager", "kube-scheduler"]
  services.each do |srv|
    describe service(srv) do
      it { should be_running }
      it { should be_enabled }
    end
  end
end
