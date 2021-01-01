# ![Grape RealWorld Example App Logo](logo.png)

> ### [Grape](https://github.com/ruby-grape/grape) codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld) spec and API.


### [Demo](https://github.com/gothinkster/realworld)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)


This codebase was created to demonstrate a fully fledged fullstack application built with **[Grape](https://github.com/ruby-grape/grape)** including CRUD operations, authentication, routing, pagination, and more.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.


# How it works

> Describe the general architecture of your app here

# Getting started

> npm install, npm start, etc.

# Instructions while in developent:
1) `docker-compose build` to build the app, once it's cloned down.
2) `docker-compose up -d` then `docker-compose run api sequel -m db/migrations postgres://postgres:abc@db:5432/conduit` to migrate the database
3) `docker-compose up`

If a migration is changed, stop the container then delete the volume that it is associated with `docker volume rm <volume_name>` - to find volumes `docker volume ls`

# To get pry to work
1) put pry in code where you want it to be & bring the server up with `docker-compose up` as above
2) in a second terminal window than the one used to bring the app up, type `docker attach grape-realworld-example-app_api_1`
3) send the request through Postman once the server is running
4) you are now in pry in that window
