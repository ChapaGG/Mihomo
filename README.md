**Конфигурации Xkeen - MiHomo**, делем с друзьями для себя.


[config.yaml](https://github.com/ChapaGG/Mihomo/blob/main/config.yaml) - основная конфигурация Mihomo
  * 1-19     строка файла для конфигурации своего подключения с именем 'PROXY'
  * 20 - ... строка - общая конфигурация

[xkeen_exclude.lst](https://github.com/ChapaGG/Mihomo/blob/main/xkeen_exclude.lst) - для исключения из обработки Xkeen
  * должен находиться /opt/etc/xkeen_exclude.lst
  * в моем случае это решило проблему с голосовым чатом в PUBG
  
[update_mihomo_config.sh](https://github.com/ChapaGG/Mihomo/blob/main/update_mihomo_config.sh) - для автообновления конфига с GitHub
  * в процессе написания.
  * будет склеивать 2 файла на кинетике ( proxy.yaml + config.yaml )
