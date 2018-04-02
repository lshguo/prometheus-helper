# prometheus-helper
Prometheus监控并存储的容器指标特别多，但客户可能只关心其中的少数几种。这种情况下，多余的监控指标只会浪费磁盘空间。

# 脚本功能
只保留指定Metric的监控记录，其余的将被删除
可以修改脚本，指定需要保留的Metric

# 脚本参数
目前只需要一个参数，即Prometheus的地址，如: 172.30.233.80:9090或http://prometheus-monitor.qyos3.com

# 备注
Prometheus版本要求2.1.0以上
