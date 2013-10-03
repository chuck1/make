-include $(root)make/Makefile.Def.mk

# todo: error handling and more advanced detection of filenames and such.
#       independent system for generating doxygen

home := ./../../
src  := $(home)src/
inc  := $(home)inc/
bin  := $(home)bin/
obj  := obj/

name      := $(patsubst %/compiler/lin64, %.a , $(subst ./, , $(subst ../, , $(shell pwd))))
name      := $(basename $(notdir $(name)))

libs      := $(shell find $(lpaths) -name *.a)
lib_pat   := $(addsuffix .a, $(addprefix %lib, $(libraries)))
libs_filt := $(filter $(lib_pat), $(libs))


hpaths     += $(inc)


cflags     := 
cflags     += -g -std=c++0x -Wall -Wno-unknown-pragmas -rdynamic -pthread
cflags     += $(addprefix -D, $(defines))
cflags     += $(addprefix -I, $(hpaths))


pre = -Wl,-rpath,


lflags     := 
lflags     += $(addprefix -L, $(lpaths))
lflags     += -Wl,--start-group $(addprefix -l, $(libraries)) -Wl,--end-group

lflags     += $(addprefix $(pre), $(lpaths))
lflags     += $(addprefix $(pre), ./../../../glew/lib/)



cpp_files  := $(shell find $(src) -name *.cpp)



o_files   = $(addprefix obj/, $(subst $(src), , $(patsubst %.cpp, %.o, $(cpp_files))))
depend    = $(addprefix depend/, $(subst ./, , $(subst ../, , $(subst $(src), , $(patsubst %.cpp, %.depend, $(cpp_files))))))



binary     := $(bin)lib64/$(name)



all:
	@clear
	@$(MAKE) -f Makefile $(binary)

debug:
	@echo "o_files  " $(o_files)
	@echo "depend   " $(depend)
	@echo "libraries" $(libraries)
	@echo "lpaths   " $(lpaths)
	@echo "libs     " $(libs)
	@echo "lib_pat  " $(lib_pat)
	@echo "libs_filt" $(libs_filt)




clean:
	@$(ECHO) clean
	@$(RMDIR) $(obj)
	@$(RMDIR) $(bin)	
	
fresh: clean all
	
$(obj)%.o: $(src)%.cpp $(libs_filt)
	@$(ECHO) compiling $<...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -c $< -o $@ $(lflags)

$(binary): $(o_files) 
	@$(ECHO) building $@...
	@$(MKDIR) $(dir $(binary))
	@$(CXX) $(cflags) -o $@ $(o_files) $(lflags)
	@$(ECHO) building $@ complete!


-include $(depend)	
