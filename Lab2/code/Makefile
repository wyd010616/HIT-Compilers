# GNU make手册：http://www.gnu.org/software/make/manual/make.html
# ************ 遇到不明白的地方请google以及阅读手册 *************

# 编译器设定和编译选项
CC = gcc
FLEX = flex
BISON = bison
CFLAGS = -std=c99

# 编译目标：src目录下的所有.c文件
CFILES = $(shell find ./ -name "*.c")
OBJS = $(CFILES:.c=.o)
LFILE = $(shell find ./ -name "*.l")
YFILE = $(shell find ./ -name "*.y")
LFC = $(shell find ./ -name "*.l" | sed s/[^/]*\\.l/lex.yy.c/)
YFC = $(shell find ./ -name "*.y" | sed s/[^/]*\\.y/syntax.tab.c/)
LFO = $(LFC:.c=.o)
YFO = $(YFC:.c=.o)

parser: syntax $(filter-out $(LFO),$(OBJS))
	$(CC) -o parser $(filter-out $(LFO),$(OBJS)) -lfl

syntax: lexical syntax-c
	$(CC) -c $(YFC) -o $(YFO)

lexical: $(LFILE)
	$(FLEX) -o $(LFC) $(LFILE)

syntax-c: $(YFILE)
	$(BISON) -o $(YFC) -d -v $(YFILE)

-include $(patsubst %.o, %.d, $(OBJS))

# 定义的一些伪目标
.PHONY: clean test
test:
	./parser ../test/1.txt
	./parser ../test/2.txt
	./parser ../test/3.txt
	./parser ../test/4.txt
	./parser ../test/5.txt
	./parser ../test/6.txt
	./parser ../test/7.txt
	./parser ../test/8.txt
	./parser ../test/9.txt
	./parser ../test/10.txt
	./parser ../test/11.txt
	./parser ../test/12.txt
	./parser ../test/13.txt
	
allTest:
	./parser ../test/14.txt
	./parser ../test/15.txt
	./parser ../test/16.txt
	./parser ../test/17.txt
	./parser ../test/18.txt
	./parser ../test/19.txt
	./parser ../test/20.txt
	./parser ../test/21.txt
	./parser ../test/22.txt
	./parser ../test/23.txt
clean:
	rm -f parser lex.yy.c syntax.tab.c syntax.tab.h syntax.output
	rm -f $(OBJS) $(OBJS:.o=.d)
	rm -f $(LFC) $(YFC) $(YFC:.c=.h)
	rm -f *~
