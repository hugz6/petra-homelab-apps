KUBE_IP=192.168.0.100

.PHONY: tf
tf:
	@$(MAKE) -C terraform terraform-apply

.PHONY: tf-destroy
tf-destroy:
	@$(MAKE) -C terraform terraform-destroy

.PHONY: ks
ks:
	@$(MAKE) -C kubespray kubespray

.PHONY: ks-clean
ks-clean:
	@$(MAKE) -C kubespray kubespray-clean

setup-kubectl:
	@ssh-keygen -f "/home/zeta/.ssh/known_hosts" -R "$(KUBE_IP)"
	@ssh ubuntu@$(KUBE_IP) "sudo cp /etc/kubernetes/admin.conf /tmp/; sudo chmod 775 /tmp/admin.conf"
	@scp ubuntu@$(KUBE_IP):/tmp/admin.conf ~/.kube/config
	@sed -i 's|server: https://127.0.0.1:6443|server: https://$(KUBE_IP):6443|g' ~/.kube/config

get-argocd-passwd:
	@kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 --decode | xclip -sel clipboard

.PHONY: cluster-reset
cluster-reset: tf-destroy tf ks ks-clean
