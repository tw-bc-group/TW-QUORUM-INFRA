NS 		?= quorum-namespace
NAME  ?= quorum 
HELM	?= helm
KUBE	?= kuberctl 

CHART := ./
H     := $(HELM) -n $(NS)
K     := $(KUBE) -n $(NS)

install:
	$(H) install $(NAME) $(CHART)

upgrade:
	$(H) upgrade $(NAME) $(CHART)

status:
	watch $(K) get all

deploy:
	$(H) upgrade --install $(NAME) $(CHART)
