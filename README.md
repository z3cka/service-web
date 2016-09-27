# Apache Docker images for Docksal

This image is configured to work with a fastcgi server and will not work without one.  
The fastcgi server:port can be set via APACHE_FCGI_HOST_PORT environment variable.


## Versions

- apache2.2
- apache2.4


## Features

- SSL enabled
- BigPipe support (on 2.2 only)
- HTTP Basic Authentication


## HTTP Basic Authentication

Use `APACHE_BASIC_AUTH_USER` and `APACHE_BASIC_AUTH_PASS` environment variables 
to set username and password.

Example (`docker-compose.yml`):

```
  ...
  environment:
    - APACHE_BASIC_AUTH_USER=user
    - APACHE_BASIC_AUTH_PASS=password
  ...
```


## License

The MIT License (MIT)

Copyright (c) 2016 blinkreaction

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
