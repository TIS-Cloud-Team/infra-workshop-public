- https://hub.docker.com/r/microsoft/dotnet-framework-samples/
- https://github.com/microsoft/dotnet-framework-docker

```powershell
docker info
docker images 
docker ps
docker ps -a
docker stop <container id>
docker start <container id>
docker rm -f <container id>

## console app
docker pull mcr.microsoft.com/dotnet/framework/samples:dotnetapp
docker run --rm mcr.microsoft.com/dotnet/framework/samples:dotnetapp

## asp.net iis dotnet framework 4.8.x
docker pull mcr.microsoft.com/dotnet/framework/samples:aspnetapp
docker run --name aspnet_sample --rm -it -p 8000:80 mcr.microsoft.com/dotnet/framework/samples:aspnetapp

```
