.PHONY: build run kill enter push pull

build:
	#-docker rmi jupyter-kn
	docker build --rm -t jupyter-kn .
buildmysql:
	docker build --rm -f ./Dockerfile.mysql -t mysql-utf8 .
run: 
	docker run -d --name jupyterServ -p 8000:8000 -p 8888:8888 -p 222:22 jupyter-kn
rerun:
	docker start jupyterServ
kill:
	-docker kill jupyterServ
	-docker rm jupyterServ
mysql:
	-docker kill mysql_5_6
	-docker rm mysql_5_6
	docker run -t --name mysql_5_6 -e MYSQL_ROOT_PASSWORD=wipm -v ~/mysql:/var/lib/mysql --publish 0.0.0.0:3306:3306 -d mysql-utf8
enter:
	docker exec -it jupyterServ sh -c "export TERM=xterm && bash"

# git commands for quick chaining of make commands
push:
	git push --all
	git push --tags

pull:
	git pull
