.PHONY: build run kill enter push pull

build:
	#-docker rmi jupyter-kn
	docker build --rm -t jupyter-kn .

run: 
	docker run -d --name jupyterServ -p 8000:8000 -p 8888:8888 -p 222:22 jupyter-kn
rerun:
	docker start jupyterServ
kill:
	-docker kill jupyterServ
	-docker rm jupyterServ

enter:
	docker exec -it jupyterServ sh -c "export TERM=xterm && bash"

# git commands for quick chaining of make commands
push:
	git push --all
	git push --tags

pull:
	git pull
