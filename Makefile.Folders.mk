

home           := ./
src            := $(home)src/
inc            := $(home)inc/
lib            := $(home)lib/$(os)/
bin            := $(home)bin/$(os)/
doc            := $(home)doc/
folder_obj     := $(home)compiler/$(os)/obj/
folder_depend  := $(home)compiler/$(os)/depend/


name      := $(patsubst %/compiler/lin64, %.a , $(subst ./, , $(subst ../, , $(shell pwd))))
name      := $(basename $(notdir $(name)))


