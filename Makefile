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
mysql:
	docker run -t --name mysql_1 -e MYSQL_ROOT_PASSWORD=wipm -v ~/mysql:/var/lib/mysql --publish 0.0.0.0:3306:3306 -d mysql
enter:
	docker exec -it jupyterServ sh -c "export TERM=xterm && bash"

# git commands for quick chaining of make commands
push:
	git push --all
	git push --tags

pull:
	git pull
