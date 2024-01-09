@echo off

set /p answer="Do you want to start a new container? (yes/no) "

if "%answer%"=="yes" (
    set /p use_new_image="Do you want to use a new Docker image? (yes/no) "
    
    if "%use_new_image%"=="yes" (
        set /p image_name="Enter the Docker image name (e.g., myimage:tag): "
    ) else (
        set image_name="mycontainer:1"
    )
    
    set /p container_name="Enter a name for the new container: "

    echo Checking for existing containers on port 2222...
    for /f "tokens=1" %%i in ('docker ps -q -f "publish=2222"') do (
        echo Stopping container %%i...
        docker stop %%i
        echo Removing container %%i...
        docker rm %%i
    )

    echo Starting new container...
    docker run -v %cd%:/opt -w /opt -d -p 2222:22 --name %container_name% %image_name%
    echo Container %container_name% started.
    ssh root@localhost -p 2222
) else (
    echo The most recent containers are:
    docker ps -a --format "{{.Names}}" | find /N /V ""
    echo.
    set /p container_name="Enter the name of the container you want to start: "
    docker start %container_name% 
    echo Container %container_name% has been started.
    echo Password is "NewGrid"
    ssh root@localhost -p 2222
)
