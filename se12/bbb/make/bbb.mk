#Standard makefile for LMI labs
include $(LMIBASE)/bbb/make/bbb_tools.mk

.PHONY: all clean lib_all

all: $(OBJDIR)/ $(EXTRA_ALL) lib_all $(EXE)

clean: $(EXTRA_CLEAN)
	rm -Rf .obj $(EXEC)_[ah] *.map *~ $(EXTRAS)
	@for dir in $(LIBDIRS);   do $(MAKE) --no-print-directory -C $$dir clean; done

lib_all:
	@for dir in $(LIBDIRS);   do $(MAKE) --no-print-directory -C $$dir all; done

$(EXE): $(OBJS) $(LINKER_SCRIPT) $(EXTRA_LIBS)
	$(LD) $(OBJS) $(LDFLAGS) -o $@ 
			
$(OBJDIR)/:
	mkdir -p $(OBJDIR)

