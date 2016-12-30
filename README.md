# Apache Docker images for Docksal

- apache2.2
- apache2.4

This image(s) is part of the [Docksal](http://docksal.io) image library.

## Features

- SSL enabled
- BigPipe support (on 2.2 only)
- HTTP Basic Authentication


## fastcgi server endpoint

These images are set up to work with a fastcgi server and will not start without one.  
The fastcgi endpoint can be set via `APACHE_FCGI_HOST_PORT` environment variable (defaults to `cli:9000`).


## HTTP Basic Authentication

Use `APACHE_BASIC_AUTH_USER` and `APACHE_BASIC_AUTH_PASS` environment variables to set username and password.

Example with Docker Compose

```
  ...
  environment:
    - APACHE_BASIC_AUTH_USER=user
    - APACHE_BASIC_AUTH_PASS=password
  ...
```
