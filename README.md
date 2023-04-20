## Тестовое задание
### Тестирование производилось на мощностях yandex cloud
###  Для разворачивания инфраструктуры использовались [манифесты](./terraform)
### Deploy k8S:
 - Для тестового приложения использовался nginx с простой конфигурацией:
- - конфигурация [html](./k8s/configmap-html.yml) странички
- - конфигурация [сервиса](./k8s/configmap-ngnixconf.yml) nginx
 - Манифест [deployment](./k8s/deployment.yml) включает в себя следующее:
- - init контейнер для подготовки пода к старту основного контейнера 
- - проверка readinessProbe перед подачей трафика в контейнер
- - ограничение ресурсов пода (в случае cpu помимо запроса на ресурсы устновлен лимит, который может понадобиться при первом старте)
 - Для уменьшения/увеличения количества реплик в зависимотси от времени суток время используется [CronJob](./k8s/cronjob.yml):
 - - для выполнения работы создан [ServiceAccount](./k8s/serviceaccount.yml)
  - Так же создан [service](./k8s/service.yml) для доступа к приложению:

```
kubectl describe service -n infra nginx-service 
Name:              nginx-service
Namespace:         infra
Labels:            <none>
Annotations:       <none>
Selector:          name=nginx
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.233.33.44
IPs:               10.233.33.44
Port:              <unset>  80/TCP
TargetPort:        8081/TCP
Endpoints:         10.233.108.196:8081,10.233.117.197:8081,10.233.83.131:8081 + 1 more...
Session Affinity:  None
Events:            <none>
```

  ```
 curl 10.233.33.44:80
<html>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<h1>Тестовое задание для mindbox</h1>
</br>
  ```

