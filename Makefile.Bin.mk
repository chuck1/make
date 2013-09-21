-include $(root)transfer/make/makefile.Def.mk


home := ./../../
src  := $(home)src/
inc  := $(home)inc/
bin  := $(home)bin/
obj  := obj/

name      := $(patsubst %/compiler/lin64, %.a , $(subst ./, , $(subst ../, , $(shell pwd))))
name      := $(basename $(notdir $(name)))



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

o_files    := $(addprefix $(obj), $(subst src/, , $(subst ./, , $(subst ../, , $(patsubst %.cpp, %.o, $(cpp_files))))))

binary     := $(bin)lib64/$(name)



all:
	@clear
	@$(ECHO) $(cpp_files)
	@$(ECHO) $(o_files)
	@$(MAKE) -f makefile $(binary)

clean:
	@$(ECHO) clean
	@$(RMDIR) $(obj)
	@$(RMDIR) $(bin)	
	
fresh: clean all
	
$(obj)%.o: $(src)%.cpp
	@$(ECHO) compiling $<...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -c $< -o $@ $(lflags)

$(binary): $(o_files)
	@$(ECHO) building $@...
	@$(MKDIR) $(dir $(binary))
	@$(CXX) $(cflags) -o $@ $(o_files) $(lflags)
	@$(ECHO) building $@ complete!


	
