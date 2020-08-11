MSIM=	ModelSimSetup-18.1.0.625-linux.run
all: $(MSIM)
	docker build -t phwl/elec3608-vsim .

$(MSIM):
	wget $(MSIM)

run:
	xhost + ${hostname}; HOSTNAME=`hostname`; DISPLAY=${HOSTNAME}:0
	docker run -it -e DISPLAY=${DISPLAY} -v ${HOME}:/mnt phwl/elec3608-vsim:latest 

clean:
	-rm -f $(MSIM)
