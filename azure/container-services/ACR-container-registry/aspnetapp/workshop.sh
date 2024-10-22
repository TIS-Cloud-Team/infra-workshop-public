## Build and run the ASP.NET Core app
docker build -t workshop-dotnetapp -f Dockerfile.chiseled .

## List the images
docker images | grep 'workshop-'

## Run the ASP.NET Core app
docker run --rm -it -p 83:8080 -e ASPNETCORE_HTTP_PORTS=8080 workshop-aspnetapp

