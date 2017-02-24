// drr2list.cpp
// C. R. Thornsberry
// Feb. 24th, 2017
// Generate a human readable .list file from an input .drr file
// SYNTAX: ./drr2list [prefix] <options>

#include <iostream>

#include "hisFile.h"

OutputHisFile *output_his;

int main(int argc, char *argv[]){
	if(argc < 2){
		std::cout << " Error: Invalid number of arguments to " << argv[0] << ". Expected 1, received " << argc-1 << ".\n";
		std::cout << "  SYNTAX: " << argv[0] << " [prefix]\n";
		return 1;
	}

	HisFile his_file(argv[1]);
	if(!his_file.IsGood()){
		his_file.GetError();
		return 1;
	}
	
	his_file.PrintHeader();
	std::cout << std::endl;
	
	his_file.WriteListFile();
	
	return 0;
}
