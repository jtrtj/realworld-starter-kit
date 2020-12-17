# ![RealWorld Example App](logo.png)

> ### [YOUR_FRAMEWORK] codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld) spec and API.


### [Demo](https://github.com/gothinkster/realworld)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)


This codebase was created to demonstrate a fully fledged fullstack application built with **[YOUR_FRAMEWORK]** including CRUD operations, authentication, routing, pagination, and more.

We've gone to great lengths to adhere to the **[YOUR_FRAMEWORK]** community styleguides & best practices.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.


# How it works

> Describe the general architecture of your app here

# Getting started

> npm install, npm start, etc.

# Instructions to get started

`docker-compose build`

`docker-compose run api sequel -m db postgres://postgres:abc@db:5432/conduit` to migrate the database

`docker-compose up`

If a migration is changed, stop the container then delete the volume that it is associated with `docker volume rm <volume_name>` - to find volumes `docker volume ls` 

# To get pry to work
1) put pry in code where you want it to be
2) send the request through postman once the server is running
3) in a second terminal window, type `docker attach grape-realworld-example-app_api_1`
4) you are now in pry
