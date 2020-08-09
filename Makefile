NS 		?= quorum-efs-namespace
NAME  ?= quorum-efs 
HELM	?= helm
KUBE	?= kubectl
EFS 	?= efs-pv

CHART := ./
H     := $(HELM) -n $(NS)
K     := $(KUBE) -n $(NS)

install:
	$(H) install $(NAME) $(CHART)

uninstall:
	$(H) uninstall $(NAME)

upgrade:
	$(H) upgrade $(NAME) $(CHART)

status:
	watch $(K) get all

watch:
	$(K) get po -n $(NS) --watch

pvc:
	$(K) get pvc -n $(NS)
	
pv:
	$(K) get pv

delete:
	$(K) delete --all deployments,configmaps,pods,pvc,service -n $(NS)

deploy:
	$(H) upgrade --install $(NAME) $(CHART)
