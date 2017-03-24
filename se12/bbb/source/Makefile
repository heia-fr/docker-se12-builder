# Copyright 2015 University of Applied Sciences Western Switzerland / Fribourg
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Project:	HEIA-FR / Embedded Systems 1+2 Laboratory
#
# Author: 	Daniel Gachet
# Date: 	21.08.2015
#

MYLIB=libbbb.a
SRCS=$(wildcard *.c) 
ASRC=$(wildcard *.S)
IPATH=-I.

# The lines below should not be modified 
TOOLCHAIN=arm-none-eabi-
CC=$(TOOLCHAIN)gcc
AS=$(TOOLCHAIN)as
AR=$(TOOLCHAIN)ar
CFLAGS=-pedantic -Wall -Wextra -c -mcpu=cortex-a8 -mfpu=vfpv3 -O0 -MD -std=c11 -g
CFLAGS+=$(IPATH) 
##CFLAGS+=-Dgcc -Dasm=__asm__
OBJDIR=.obj
OBJS= $(addprefix $(OBJDIR)/, $(ASRC:.S=.o) $(SRCS:.c=.o))


.PHONY: all clean install

all: $(OBJDIR)/ $(MYLIB)
	
$(MYLIB): $(OBJS)
	@echo "[ar] --> generate libbbb.a"
	@$(AR) rcs $@  $(OBJS)

$(OBJDIR)/%o: %c
	$(CC) $(CFLAGS) $< -o $@
	
$(OBJDIR)/%o: %S
	$(CC) $(CFLAGS) $< -o $@	

$(OBJDIR)/:
	mkdir -p $(OBJDIR)
	@for dir in $(LIBDIR); do mkdir -p $$dir; done
 
-include $(OBJS:.o=.d)

clean:
	rm -Rf $(OBJDIR) $(MYLIB) *~
