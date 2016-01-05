NAME="openchain/devbase"
IMAGE= openchain-devbase.box

all: $(IMAGE)

$(IMAGE):
	vagrant destroy -f
	vagrant up
	vagrant package --output $@
	vagrant destroy -f

install: $(IMAGE) remove
	vagrant box add -name $(NAME) $(IMAGE)

remove:
	-vagrant box remove $(NAME)

clean: remove
	-rm $(IMAGE)
