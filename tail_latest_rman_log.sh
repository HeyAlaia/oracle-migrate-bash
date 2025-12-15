#!/bin/bash

# --- 配置 ---
LOG_DIR="/home/oracle/backupcmd" # 日志文件所在的目录，默认为当前目录。如果您日志在其他目录，请修改这里。
LOG_PATTERN="eportdb_all_data_recovery_*.log" # 日志文件的命名模式

# --- 脚本逻辑 ---

# 检查日志目录是否存在
if [ ! -d "$LOG_DIR" ]; then
	  echo "错误: 日志目录 '$LOG_DIR' 不存在。"
	    exit 1
fi

echo "正在 '$LOG_DIR' 目录中查找最新日志文件..."

# 查找最新的日志文件
# -t 选项按修改时间排序（最近修改的在前）
# -r 选项反向排序（与 -t 结合，效果是最新修改的在前）
# head -n 1 提取第一行（即最新的文件）
LATEST_LOG_FILE=$(ls -t ${LOG_DIR}/${LOG_PATTERN} 2>/dev/null | head -n 1)

# 检查是否找到了日志文件
if [ -z "$LATEST_LOG_FILE" ]; then
	  echo "未找到符合模式 '$LOG_PATTERN' 的日志文件。"
	    exit 1
fi

echo "---------------------------------------------------------"
echo "已找到最新日志文件: $LATEST_LOG_FILE"
echo "正在实时跟踪日志 (Ctrl+C 退出)..."
echo "---------------------------------------------------------"

# 实时跟踪日志文件
tail -f -n200 "$LATEST_LOG_FILE"

echo ""
echo "日志跟踪已结束。"

