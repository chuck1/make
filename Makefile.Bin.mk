os := lin64

-include $(root)make/Makefile.Def.mk
-include $(root)make/Makefile.Folders.mk


# todo: error handling and more advanced detection of filenames and such.
#       independent system for generating doxygen


file_goal     := $(bin)$(name)



-include $(root)make/Makefile.Cpp.mk



$(file_goal): $(files_obj) $(libs_filt)
	@$(ECHO) building $@...
	@$(MKDIR) $(dir $@)
	@$(CXX) $(cflags) -o $@ $(files_obj) $(lflags)
	@$(ECHO) building $@ complete!


