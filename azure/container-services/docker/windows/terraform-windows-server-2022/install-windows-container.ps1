# install_docker.ps1
Install-WindowsFeature -Name Containers; && Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart; && Invoke-WebRequest -Uri https://download.docker.com/components/engine/windows-server/20.10/docker-20.10.7.zip -OutFile C:\Users\Public\docker.zip; && Expand-Archive -Path C:\Users\Public\docker.zip -DestinationPath C:\Program Files\Docker;
[Environment]::SetEnvironmentVariable('PATH', $Env:PATH + ';C:\Program Files\Docker', [EnvironmentVariableTarget]::Machine)
Start-Service docker
docker version