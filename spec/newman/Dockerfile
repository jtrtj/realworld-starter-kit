FROM postman/newman:alpine

COPY Conduit.postman_environment.json .

CMD ["run", "https://raw.githubusercontent.com/gothinkster/realworld/master/api/Conduit.postman_collection.json", \
"-e", "Conduit.postman_environment.json"]
