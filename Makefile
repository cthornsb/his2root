#####################################################################

# Installer for his2root
# Cory R. Thornsberry
# updated: Nov. 24th, 2016

#####################################################################

# Set the binary install directory.
INSTALL_DIR = $(HOME)/bin

#####################################################################

CC = g++

#CFLAGS = -g -fPIC -Wall -std=c++0x `root-config --cflags` -Iinclude
CFLAGS = -fPIC -Wall -O3 -std=c++0x `root-config --cflags` -Iinclude
LDLIBS = -lstdc++ `root-config --libs`
LDFLAGS = `root-config --glibs`

# Directories
TOP_LEVEL = $(shell pwd)
INCLUDE_DIR = $(TOP_LEVEL)/include
SOURCE_DIR = $(TOP_LEVEL)/source
EXEC_DIR = $(TOP_LEVEL)/exec
OBJ_DIR = $(TOP_LEVEL)/obj

# Tools
ALL_TOOLS = his2root \
            hisReader \
            drr2list 
EXE_NAMES = $(addprefix $(EXEC_DIR)/, $(addsuffix .a, $(ALL_TOOLS)))
INSTALLED = $(addprefix $(INSTALL_DIR)/, $(ALL_TOOLS))

# List of directories to generate if they do not exist.
DIRECTORIES = $(OBJ_DIR) $(EXEC_DIR)

# C++ CORE
SOURCES = hisFile.cpp

# C++ object files
OBJECTS = $(addprefix $(OBJ_DIR)/,$(SOURCES:.cpp=.o))

#####################################################################

all: $(DIRECTORIES) $(EXE_NAMES)
#	Create all directories, make all objects, and link executable

.PHONY: $(ALL_TOOLS) $(INSTALLED) $(DIRECTORIES)

#####################################################################

$(DIRECTORIES): 
#	Make the default configuration directory
	@if [ ! -d $@ ]; then \
		echo "Making directory: "$@; \
		mkdir -p $@; \
	fi

#####################################################################

$(OBJ_DIR)/%.o: $(SOURCE_DIR)/%.cpp
#	Compile C++ source files
	$(CC) $(CFLAGS) -c $< -o $@

$(EXEC_DIR)/%.a: $(SOURCE_DIR)/%.cpp $(OBJECTS)
#	Compile C++ source files
	$(CC) $(CFLAGS) $< $(OBJECTS) -o $@ $(LDLIBS)

#####################################################################

$(ALL_TOOLS):
	@echo " Installing "$(INSTALL_DIR)/$@
	@rm -f $(INSTALL_DIR)/$@
	@ln -s $(EXEC_DIR)/$@.a $(INSTALL_DIR)/$@

install: all $(ALL_TOOLS)
	@echo "Finished installing tools to "$(INSTALL_DIR)

########################################################################

$(INSTALLED):
	@rm -f $@

uninstall: $(INSTALLED)
	@echo "Finished uninstalling";

tidy: clean uninstall
	@rm -f $(EXE_NAMES)

clean:
	@rm -f $(OBJ_DIR)/*.o
