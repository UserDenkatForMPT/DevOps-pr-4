@echo off

:: Имя контейнера и образа
set container_name=calcjavacont
set image_name=calcjavaimg

chcp 65001

:: желтый
echo [33m[INFO] Начинаю остановку контейнера %container_name%.[0m

:: Остановить и удалить контейнер
docker stop %container_name%
docker rm %container_name%

:: зеленый
echo [32m[INFO] Старый контейнер %container_name% остановлен и удален.
echo. 
echo.

echo [33m[INFO] Начинаю остановку контейнеров, которые используют образ %image_name%.[0m
:: Удалить образ и связанные с ним контейнеры
for /f %%i in ('docker ps -a --filter "ancestor=%image_name%" -q') do (
    docker stop %%i
    docker rm %%i
)
echo [32m[INFO] Остановлены контейнеры, которые использовали образ %image_name%.[0m
echo. 
echo.

echo [33m[INFO] Начинаю удаление старого образа %image_name%.[0m
docker rmi %image_name%
echo [32m[INFO] Старый образ %image_name% удален.[0m
echo. 
echo.

echo [33m[INFO] Начинаю сборку образа %image_name%.[0m
docker build -t %image_name% .
echo [32m[INFO] Образ %image_name% собран.[0m
echo. 
echo.

:: Запустить контейнер с обновленным образом
docker run --name %container_name% -it %image_name% 
@REM echo [INFO] container %container_name% run.