NS 		:= quorum-namespace
NAME  := quorum 
CHART := ./
HELM	:= helm
H     ?= $(HELM) -n $(NS)
K     := kuberctl -n $(NS)

install:
	$(H) install $(NAME) $(CHART)

upgrade:
	$(H) upgrade $(NAME) $(CHART)

status:
	watch $(K) get all

deploy:
	$(H) --install $(NAME) $(CHART)
