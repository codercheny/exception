# ------------------------------------------------------------------------------
# name:   C/C++ makefile
# author: chenyao
# mail:   cheny@meizu.com
# date:   2018年 06月 28日 星期四 15:54:24 CST
# 
# directory:
# 	bin/
# 		main
# 	obj/
# 		*.o
# 		*.d
# 	include/
# 		*.h
# 	source/
# 		*.cpp
#
# ------------------------------------------------------------------------------
#
#
# ------------------------------------------------------------------------------
TARGET   :=main
LIBS     :=

PATH_LIB :=
PATH_INC :=include
PATH_SRC :=$(shell ls -R | grep '^\./.*:$$' | awk '{gsub(":","");print}')
PATH_OBJ :=obj/
PATH_BIN :=

CXX      :=g++
CXXFLAGS :=-g -Wall -O3
CXXFLAGS +=$(addprefix -I,$(PATH_INC))
CXXFLAGS +=-std=c++11

RM :=rm -f

BINS :=$(addprefix $(PATH_BIN),$(TARGET))
SRCS :=$(foreach n,$(PATH_SRC),$(wildcard $(addsuffix .cpp,$(n)/*))) 
OBJS :=$(addprefix $(PATH_OBJ),$(addsuffix .o,$(basename $(notdir $(SRCS))))) 
DEPS :=$(patsubst %.o,%.d,$(OBJS))

vpath %.h   $(PATH_INC)
vpath %.cpp $(PATH_SRC)


.PHONY: all clean rebuild info

all: $(PATH_BIN) $(PATH_OBJ) $(BINS)

$(PATH_BIN): ; -mkdir $(PATH_BIN)
$(PATH_OBJ): ; -mkdir $(PATH_OBJ)

$(PATH_OBJ)%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(PATH_OBJ)%.d: %.cpp
	@set -e; rm -f $@; \
	$(CXX) -MM $(CXXFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,$(PATH_OBJ)\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

-include $(DEPS)

$(BINS): $(OBJS)
	$(CXX) -o $(BINS) $(OBJS) $(addprefix -l,$(LIBS))

clean:
	@$(RM) $(BINS)
	@$(RM) $(OBJS)
	@$(RM) $(DEPS)

rebuild: clean all

info:
	@echo binexe:$(BINS)
	@echo source:$(SRCS)
	@echo object:$(OBJS)
	@echo depend:$(DEPS)
	@echo depend_miss:$(DEPS_MISS)
