# 默认编译器和工具  
CC ?= gcc  
STRIP ?= strip  
  
# 默认编译标志（最小体积优化）  
CFLAGS ?= -Os -ffunction-sections -fdata-sections -Wall -Wextra  
LDFLAGS ?= -Wl,--gc-sections -Wl,--as-needed  
  
# 静态编译标志（可选）  
ifdef STATIC  
    LDFLAGS += -static  
endif  
  
# 依赖库  
LIBS_CLI = -lm  
LIBS_HTTP = -lm -lpthread -lz 
  
# 目标文件  
TARGETS = n2n_check_cli n2n_check_http  
  
# 彩色输出定义  
COLOR_RESET = \033[0m  
COLOR_GREEN = \033[32m  
COLOR_YELLOW = \033[33m  
COLOR_BLUE = \033[34m  
COLOR_CYAN = \033[36m  
  
# 默认目标  
all: $(TARGETS)  
	@echo "$(COLOR_GREEN)✓ 编译完成$(COLOR_RESET)"  
  
# 编译 n2n_check_cli  
n2n_check_cli: cli.c  
	@echo "$(COLOR_CYAN)→ 编译 n2n_check_cli...$(COLOR_RESET)"  
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LIBS_CLI)  
	@echo "$(COLOR_YELLOW)→ 执行 strip n2n_check_cli...$(COLOR_RESET)"  
	@$(STRIP) $@ 2>/dev/null || echo "$(COLOR_YELLOW)⚠ 警告: strip 失败 ($$?), 可执行文件未优化但仍可使用$(COLOR_RESET)"  
	@echo "$(COLOR_GREEN)✓ n2n_check_cli 编译完成$(COLOR_RESET)"  
  
# 编译 n2n_check_http  
n2n_check_http: main.c  
	@echo "$(COLOR_CYAN)→ 编译 n2n_check_http...$(COLOR_RESET)"  
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LIBS_HTTP)  
	@echo "$(COLOR_YELLOW)→ 执行 strip n2n_check_http...$(COLOR_RESET)"  
	@$(STRIP) $@ 2>/dev/null || echo "$(COLOR_YELLOW)⚠ 警告: strip 失败 ($$?), 可执行文件未优化但仍可使用$(COLOR_RESET)"  
	@echo "$(COLOR_GREEN)✓ n2n_check_http 编译完成$(COLOR_RESET)"  
  
# 静态编译目标  
static:  
	@echo "$(COLOR_BLUE)→ 静态编译模式$(COLOR_RESET)"  
	$(MAKE) STATIC=1  
  
# 清理目标  
clean:  
	@echo "$(COLOR_YELLOW)→ 清理编译文件...$(COLOR_RESET)"  
	rm -f $(TARGETS)  
	@echo "$(COLOR_GREEN)✓ 清理完成$(COLOR_RESET)"  
  
# 安装目标（可选）  
install: all  
	@echo "$(COLOR_CYAN)→ 安装到 /usr/local/bin...$(COLOR_RESET)"  
	install -m 755 n2n_check_cli /usr/local/bin/  
	install -m 755 n2n_check_http /usr/local/bin/  
	@echo "$(COLOR_GREEN)✓ 安装完成$(COLOR_RESET)"  
  
# 显示编译信息  
info:  
	@echo "$(COLOR_BLUE)编译器: $(CC)$(COLOR_RESET)"  
	@echo "$(COLOR_BLUE)Strip 工具: $(STRIP)$(COLOR_RESET)"  
	@echo "$(COLOR_BLUE)CFLAGS: $(CFLAGS)$(COLOR_RESET)"  
	@echo "$(COLOR_BLUE)LDFLAGS: $(LDFLAGS)$(COLOR_RESET)"  
  
.PHONY: all clean install info static
