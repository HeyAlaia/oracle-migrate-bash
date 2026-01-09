source /home/oracle/.bash_profile
datestr=$(date +%Y%m%d%H%M%S)
if [ `date +%u` = 4 ]
then
########## 星期四01:00开始数据库全备份,其他时间只备份归档日志
rman log="/home/oracle/backupcmd/backuplog/bk_db_level_0_${datestr}.log"  append <<EOF
connect target /
set echo on
run 
{
show all;
crosscheck backup;
delete noprompt obsolete;
delete noprompt expired backup;
 
backup as  backupset incremental level=0 database   tag='level0' include current controlfile;
backup archivelog all not backed up   delete all input;

##备份控制文件到文件系统，而不是ASM
backup current controlfile  spfile;
}
exit
EOF
##删除30天以前的备份日志
##find /home/oracle/backupcmd -name "bk_*.log" -ctime +30 -exec rm -f {} \;
else
rman log="/home/oracle/backupcmd/backuplog/bk_db_level_1_${datestr}.log"  append <<EOF
connect target /
set echo on
run 
{
show all;
backup incremental level 1   database   tag='${datestr}' include current controlfile;
 sql 'alter system archive log current';
backup  archivelog all not backed up   delete all input;  
##备份控制文件到文件系统，而不是ASM
backup current controlfile spfile;
}
exit
EOF
fi
cp -rf /home/oracle/backupcmd/* /backup_2024/backup_2026/

##删除30天以前的备份日志
find /backup_2024/backuplog -name "bk_*.log" -ctime +30 -exec rm -f {} \;
chmod o+r /backup_2024/*
