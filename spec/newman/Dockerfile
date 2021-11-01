FROM postman/newman:alpine

COPY Conduit.postman_environment.json .

CMD ["run", "https://github.com/gothinkster/realworld/blob/main/api/Conduit.postman_collection.json", \
"-e", "Conduit.postman_environment.json"]
