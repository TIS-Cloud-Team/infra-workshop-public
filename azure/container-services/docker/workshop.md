## https://docs.docker.com/samples/

- azure virtual machine (linux & windows) https://learn.microsoft.com/en-us/azure/virtual-machines/
- terraform (linux) https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform?tabs=azure-cli
- terraform (windows) https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-terraform

## Supported Linux distros

[](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/README.md#supported-linux-distros)

The .NET Team publishes images for [multiple distros](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-platforms.md).

Samples are provided for:

* [Alpine](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.alpine)
* [Alpine with Composite ready-to-run image](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.alpine-composite)
* [Alpine with ICU installed](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.alpine-icu)
* [Debian](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.debian)
* [Ubuntu](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.ubuntu)
* [Ubuntu Chiseled](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.chiseled)
* [Ubuntu Chiseled with Composite ready-to-run image](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.chiseled-composite)

## Supported Windows versions

[](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/README.md#supported-windows-versions)

The .NET Team publishes images for [multiple Windows versions](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-platforms.md). You must have [Windows containers enabled](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers) to use these images.

Samples are provided for

* [Nano Server](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.nanoserver)
* [Windows Server Core](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.windowsservercore)
* [Windows Server Core with IIS](https://github.com/dotnet/dotnet-docker/blob/main/samples/aspnetapp/Dockerfile.windowsservercore-iis)

Windows variants of the sample can be pulled via one the following registry addresses:

* `mcr.microsoft.com/dotnet/samples:aspnetapp-nanoserver-1809`
* `mcr.microsoft.com/dotnet/samples:aspnetapp-nanoserver-ltsc2022`
