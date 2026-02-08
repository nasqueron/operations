TERRAFORM_STATES=terraform.tfstate terraform.tfstate.backup

SALT=sudo -u salt salt
RM=rm -f

AUDIT_DATE != date -u +%Y-%m-%dT%H:%M:%SZ
AUDIT_LOG=/var/log/deploy.log

.PHONY: all rotate provision deploy clean

all:
	@echo "There is no default target. Use 'make rotate' to rotate all secrets."

rotate: provision deploy clean
	@echo "[$(AUDIT_DATE)] <$(USER)> Terraform :: Vault :: Full secrets rotation" >> $(AUDIT_LOG)

provision:
	terraform init
	terraform plan
	terraform apply -auto-approve

deploy:
	$(SALT) windriver state.sls_id /usr/local/etc/secrets/rhyne-wyse.yaml roles/reports/rhyne-wyse/config
	$(SALT) windriver state.sls_id /srv/viperserv/.credentials roles/viperserv/eggdrop/config

clean:
	$(RM) $(TERRAFORM_STATES)
