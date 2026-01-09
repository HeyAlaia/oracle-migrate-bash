# 执行方式
``` bash
# 编辑
crontab -e
# 查看
crontab -l
```
每日定时启动: 0 1 * * * /home/oracle/backupcmd/bk_append.sh > /home/oracle/backupcmd/cron.log 2>&1

# 核心
使用l0日志和l1日志进行备份, 配合迁移脚本进行恢复
