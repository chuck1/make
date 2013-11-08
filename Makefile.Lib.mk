os := lin64

-include $(root)make/Makefile.Def.mk
-include $(root)make/Makefile.Folders.mk

file_goal := $(lib)lib$(name).a

-include $(root)make/Makefile.Cpp.mk

$(file_goal): $(files_obj)
	@$(MKDIR) $(dir $@)
	@$(AR) rcs $@ $(files_obj)
	@$(ECHO) building $@ complete!


