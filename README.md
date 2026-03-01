**Конфигурации Xkeen - MiHomo**
 * делаем с друзьями для себя, но может еще кому будет полезно, пользуйтесь.

>[!WARNING]
>Данный материал подготовлен в научно-технических и ознакомительных целях. Автор не несёт ответственности за иное использование предоставленного материала. Перед использованием убедитесь, что ваши действия соответствуют законодательству вашей страны. Использование в противоправных целях строго запрещено. Коммерческая эксплуатация предоставленного материала не допускается.

[config.yaml](https://github.com/ChapaGG/Mihomo/blob/main/config.yaml) - основная конфигурация Mihomo
* нужно расположить в /opt/etc/mihomo/config.yaml


[proxies.yaml](https://github.com/ChapaGG/Mihomo/blob/main/proxies.yaml) - локальная конфигурация всех прокси
* нужно расположить в /opt/etc/mihomo/proxies.yaml

  
[config.json](https://github.com/ChapaGG/Mihomo/blob/main/config.json) - конфиг для панели [Xkeen UI 0.6.2+](https://github.com/zxc-rv/XKeen-UI)
* нужно расположить в /opt/share/www/XKeen-UI/


Новые файлы для 1.1.3.9+ должны находиться в папке /opt/etc/xkeen/
  * [port_proxying.lst](https://github.com/ChapaGG/Mihomo/blob/main/port_proxying.lst) -список портов на которых работает Xkeen
  * [port_exclude.lst](https://github.com/ChapaGG/Mihomo/blob/main/port_exclude.lst) - список портов для исключения из обработки Xkeen
  * [ip_exclude.lst](https://github.com/ChapaGG/Mihomo/blob/main/ip_exclude.lst) - список ip для исключения из обработки Xkeen
    
[update_mihomo_config.sh](https://github.com/ChapaGG/Mihomo/blob/main/update_mihomo_config.sh) - для автообновления конфига с GitHub
  * в процессе написания.
  * просто шаблон составленный AI, пока просто набросок
