home           := ./
src            := $(home)src/
inc            := $(home)inc/
lib            := $(home)lib/$(os)/
bin            := $(home)bin/$(os)/
doc            := $(home)doc/

name      := $(patsubst %/compiler/lin64, %.a , $(subst ./, , $(subst ../, , $(shell pwd))))
name      := $(basename $(notdir $(name)))

ifeq ($(mode),lib)
	folder_goal := $(lib)
	file_goal := $(folder_goal)lib$(name).a
else
ifeq ($(mode),bin)
	folder_goal := $(bin)
	file_goal := $(folder_goal)$(name)
else
	$(error mode must be bin or lib)
endif
endif

folder_obj     := $(folder_goal)obj/
folder_depend  := $(folder_goal)depend/

