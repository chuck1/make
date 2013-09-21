


home      := ./../../
src       := $(home)src/
inc       := $(home)inc/
lib       := $(home)lib/
doc       := $(home)doc/


-include $(root)make/Makefile.Def.mk

name      := $(patsubst %/compiler/lin64, %.a , $(subst ./, , $(subst ../, , $(shell pwd))))
name      := $(basename $(notdir $(name)))


hpaths    += $(inc)


cflags    := 
cflags    += -g -std=c++0x -Wall -Wno-unknown-pragmas -rdynamic -pthread
cflags    += $(addprefix -D, $(defines))
cflags    += $(addprefix -I, $(hpaths))


lflags    += $(addprefix -L, $(lpaths))
lflags    += -Wl,--start-group $(addprefix -l, $(libraries)) -Wl,--end-group


all_cppfiles := $(shell find $(src) -name *.cpp)

ign_paths :=
ign_paths += $(shell find $(src) -name win)
ign_paths += $(shell find $(src) -name old)


ign_files := $(foreach ign_path,$(ign_paths), $(filter $(ign_path)%, $(all_cppfiles)))


cppfiles  := $(filter-out $(ign_files), $(all_cppfiles))


obj       = $(addprefix obj/, $(subst $(src), , $(patsubst %.cpp, %.o, $(cppfiles))))
depend    = $(addprefix depend/, $(subst ./, , $(subst ../, , $(patsubst %.cpp, %.depend, $(cppfiles)))))


bin       := $(lib)lin64/lib$(name).a




all:
	@clear
	@$(MAKE) -f Makefile $(bin)

	
obj/%.o: $(src)%.cpp
	@$(ECHO) compiling $<...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -c $< -o $@ $(lflags)	

depend/%.depend: $(src)%.cpp
	@$(ECHO) compiling header dependencies for $<...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -MT obj/$*.o -MM $< > $@

$(bin): $(obj)
	@$(MKDIR) $(dir $@)
	@$(AR) rcs $(bin) $(obj)
	@$(ECHO) building $@ complete!

clean:
	@$(ECHO) clean
	@$(RMDIR) obj
	@$(RMDIR) depend
	@$(RMDIR) $(bin)

fresh: clean all

-include $(depend)




