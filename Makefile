# Makefile for his2root
# updated: Nov. 12th, 2015
# Cory R. Thornsberry

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
OBJ_DIR = $(TOP_LEVEL)/obj

INSTALL_DIR = ~/bin

# Executables
HIS_2_ROOT = his2root
HIS_2_ROOT_SRC = $(SOURCE_DIR)/his2root.cpp
HIS_2_ROOT_OBJ = $(OBJ_DIR)/his2root.o
HIS_READER = hisReader
HIS_READER_SRC = $(SOURCE_DIR)/hisReader.cpp
HIS_READER_OBJ = $(OBJ_DIR)/hisReader.o

# C++ CORE
SOURCES = hisFile.cpp

# C++ object files
OBJECTS = $(addprefix $(OBJ_DIR)/,$(SOURCES:.cpp=.o))

#####################################################################

all: $(OBJ_DIR) $(HIS_2_ROOT) $(HIS_READER)
#	Create all directories, make all objects, and link executable

#####################################################################

$(OBJ_DIR):
#	Make the object file directory
	@if [ ! -d $@ ]; then \
		echo "Making directory: "$@; \
		mkdir $@; \
	fi

#####################################################################

$(OBJ_DIR)/%.o: $(SOURCE_DIR)/%.cpp
#	Compile C++ source files
	$(CC) -c $(CFLAGS) $< -o $@

#####################################################################

$(HIS_2_ROOT): $(OBJECTS) $(HIS_2_ROOT_OBJ)
	$(CC) $(LDFLAGS) $(OBJECTS) $(HIS_2_ROOT_OBJ) -o $@ $(LDLIBS)

$(HIS_READER): $(OBJECTS) $(HIS_READER_OBJ)
	$(CC) $(LDFLAGS) $(OBJECTS) $(HIS_READER_OBJ) -o $@ $(LDLIBS)

#####################################################################

install: $(HIS_2_ROOT) $(HIS_READER)
#	Install tools into the install directory
	@echo "Installing tools to "$(INSTALL_DIR)
	@ln -s -f $(TOP_LEVEL)/$(HIS_2_ROOT) $(INSTALL_DIR)/his2root
	@ln -s -f $(TOP_LEVEL)/$(HIS_READER) $(INSTALL_DIR)/hisReader

#####################################################################

tidy: clean
	@rm -f $(HIS_2_ROOT) $(HIS_READER)
	@rm -f $(INSTALL_DIR)/his2root $(INSTALL_DIR)/hisReader

clean:
	@rm -f $(OBJ_DIR)/*.o
