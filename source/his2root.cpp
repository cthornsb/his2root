// his2root.cpp
// C. Thornsberry
// Jul. 2nd, 2015
// Convert histograms in a damm .his file to .root TH1s and TH2s
// SYNTAX: ./his2root [filename] [prefix] <options>

#include <iostream>
#include <string>

#include "TNamed.h"
#include "TFile.h"
#include "TH1I.h"
#include "TH2I.h"

#include "hisFile.h"

OutputHisFile *output_his = NULL;

void help(char * prog_name_){
	std::cout << "  SYNTAX: " << prog_name_ << " [prefix] <options>\n";
	std::cout << "   Available options:\n";
	std::cout << "    --verbose | Print .drr histogram information.\n";
}

int main(int argc, char *argv[]){
	if(argc < 2){
		std::cout << " Error: Invalid number of arguments to " << argv[0] << ". Expected 1, received " << argc-1 << ".\n";
		help(argv[0]);
		return 1;
	}

	// Check for command line options.
	bool verbose = false;
	int arg_index = 2;
	while(arg_index < argc){
		if(strcmp(argv[arg_index], "--verbose") == 0){ verbose = true; }
		else{ 
			std::cout << " Error: Encountered unrecognized option '" << argv[arg_index] << "'\n";
			return 1;
		}
		arg_index++;
	}

	// Open the input his file and drr file.
	HisFile his_file(argv[1]);
	if(!his_file.IsGood()){
		his_file.GetError();
		return 1;
	}

	std::string output_fname(argv[1]);
	output_fname += ".root";
	
	// Check that the output root file does not exist.
	TFile *file = new TFile(output_fname.c_str(), "CREATE");
	if(!file->IsOpen()){ // The file exists. Do we overwrite it?
		file->Close();
		delete file;

		std::string dummy;
		std::cout << " Warning: Output file '" << output_fname << "' already exists.\n";
		std::cout << "  Would you like to overwrite it? (y/n) "; std::cin >> dummy;
		if(!(dummy == "y" || dummy == "Y" || dummy == "yes")){
			std::cout << "\n ABORTING!\n";
			return 1;
		}
		
		std::cout << std::endl;

		file = new TFile(output_fname.c_str(), "RECREATE");
		if(!file->IsOpen()){
			std::cout << " Error: Failed to open output file '" << output_fname << "'\n";
			return 1;
		}
	}
	
	file->cd();
	
	// Print the drr file header.
	if(verbose){
		his_file.PrintHeader();
		std::cout << std::endl;
	}
	
	TNamed *name = new TNamed("date", his_file.GetDate().c_str());
	name->Write();
	name->Delete();
	
	int count = 0;
	while(his_file.GetNextHistogram() > 0){
		if(verbose){ 
			his_file.PrintEntry(); 
			std::cout << std::endl;
		}
		if(his_file.GetDimension() == 1){
			TH1I *h1 = his_file.GetTH1();
			if(h1){
				h1->Write();
				h1->Delete();
			}
			count++;
		}
		else if(his_file.GetDimension() == 2){
			TH2I *h2 = his_file.GetTH2();
			if(h2){
				h2->Write();
				h2->Delete();
			}
			count++;
		}
		else{
			std::cout << " Warning! Unsupported histogram dimension (" << his_file.GetDimension() << ") for id = " << his_file.GetHisID() << std::endl;
		}
	}
	
	int err_code = his_file.GetError(false);
	if(err_code != 0 && err_code != 5){
		his_file.GetError();
		std::cout << std::endl;
	}
	
	std::cout << " Done! Wrote " << count << " histograms to '" << output_fname << "'\n";
	std::streampos rsize = (std::streampos)file->GetSize();
	std::cout << "  Output file size is " << rsize << " bytes, reduction of " << 100*(1-(1.0*rsize)/his_file.GetHisFilesize()) << "%\n";
	
	file->Close();
	
	return 0;
}
