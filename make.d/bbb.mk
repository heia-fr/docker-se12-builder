#Standard makefile for LMI labs

ifeq ($(OS),Windows_NT)
DEL=del /F /S /Q
MKDIR=mkdir
RMDIR=rmdir /S /Q
else
DEL=rm -Rf
MKDIR=mkdir -p
RMDIR=rm -Rf
endif

ifneq ($(LIBDIRS),)
LIBALL=lib_all
LIBALL_CLEAN=lib_all_clean
endif

include $(LMIBASE)/bbb/make/bbb_tools.mk

.PHONY: all clean lib_all

all: $(OBJDIR) $(EXTRA_ALL) $(LIBALL) $(EXE)

clean: $(EXTRA_CLEAN) $(LIBALL_CLEAN)
	-$(DEL) $(EXE) $(EXEC)_[ahp] *.map *~ $(EXTRAS)
	-$(RMDIR) .obj	
	
lib_all_clean:
	@for dir in $(LIBDIRS);   do $(MAKE) --no-print-directory -C $$dir clean; done
	
lib_all:
	@for dir in $(LIBDIRS);   do $(MAKE) --no-print-directory -C $$dir all; done

$(EXE): $(OBJS) $(LINKER_SCRIPT) $(EXTRA_LIBS)
	$(LD) $(OBJS) $(LDFLAGS) -o $@ 
			
$(OBJDIR):
	echo $(OBJDIR)
	$(MKDIR) $(OBJDIR)

-include $(OBJS:.o=.d)


