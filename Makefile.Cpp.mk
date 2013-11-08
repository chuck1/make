

os := lin64


hpaths    += $(inc)


cflags    := 
cflags    += -g -std=c++0x -Wall -Wno-unknown-pragmas -rdynamic -pthread
cflags    += $(addprefix -D, $(defines))
cflags    += $(addprefix -I, $(hpaths))


lflags    += $(addprefix -L, $(lpaths))
lflags    += -Wl,--start-group $(addprefix -l, $(libraries)) -Wl,--end-group


pre = -Wl,-rpath,

lflags += $(addprefix $(pre), $(lpaths))






libs      := $(shell find $(lpaths) -name *.a)
lib_pat   := $(addsuffix .a, $(addprefix %lib, $(libraries)))
libs_filt := $(filter $(lib_pat), $(libs))


all_cppfiles := $(shell find $(src) -name *.cpp)

count_cppfiles := $(shell find $(src) -name *.cpp | wc -l)

ign_paths :=
ign_paths += $(shell find $(src) -name win)
ign_paths += $(shell find $(src) -name old)

ign_files := $(foreach ign_path,$(ign_paths), $(filter $(ign_path)%, $(all_cppfiles)))


cppfiles  := $(filter-out $(ign_files), $(all_cppfiles))


files_obj       = $(subst $(src), $(folder_obj),     $(patsubst %.cpp, %.o     , $(cppfiles)))
files_depend    = $(subst $(src), $(folder_depend),  $(patsubst %.cpp, %.depend, $(cppfiles)))






all:
	@clear
	@$(MAKE) -f Makefile $(file_goal)


debug:
	@echo "fldr src  " $(src)
	@echo "cpp files " $(cppfiles)
	@echo "depend    " $(depend)
	@echo "libraries " $(libraries)
	@echo "lpaths    " $(lpaths)
	@echo "libs      " $(libs)
	@echo "lib_pat   " $(lib_pat)
	@echo "libs_filt " $(libs_filt)


	
$(folder_obj)%.o: $(src)%.cpp $(libs_filt)
	@$(ECHO) compiling  of $(count_cppfiles) $<...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -c $< -o $@ $(lflags)	



$(folder_depend)%.depend: $(src)%.cpp
	@$(ECHO) compiling header dependencies for $<...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -MT obj/$*.o -MM $< > $@


clean:
	@$(ECHO) clean
	@$(RMDIR) $(folder_obj)
	@$(RMDIR) $(folder_depend)
	@$(RMDIR) $(file_goal)

fresh: clean all

-include $(depend)




