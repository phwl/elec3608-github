all:
	docker build -t phwl/elec3608-riscv .

run:
	xhost + ${hostname}; HOSTNAME=`hostname`; DISPLAY=${HOSTNAME}:0
	docker run -it -v ${HOME}:/mnt phwl/elec3608-riscv:latest 
