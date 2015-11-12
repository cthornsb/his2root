// hisReader.cpp
// C. Thornsberry
// Jul. 2nd, 2015
// Read information about histograms in a damm .his file
// SYNTAX: ./his2root [prefix] <options>

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
	
	while(his_file.GetNextHistogram(false) > 0){
		his_file.PrintEntry(); 
		std::cout << std::endl;
	}
	
	return 0;
}
