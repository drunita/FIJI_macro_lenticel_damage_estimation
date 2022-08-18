IMAGEJ = /mnt/c/Users/Dru/Documents/Fiji.app/ImageJ-linux64

default: clean_final

ABSPATH = $(realpath $(DIR))

severity: clean_inicial
	@if [ -z $(DIR) ]; then echo "Need to run DIR=path" && exit 1; fi 
	$(IMAGEJ) --headless -macro macro_laheadlesshead.ijm $(ABSPATH)
	python3 severity_lenticelosis.py $(ABSPATH)
	
clean_inicial:
	@if [ -z $(DIR) ]; then echo "Need to run DIR=path" && exit 1; fi 
	@$(RM) $(DIR)/*_bitmask.jpg
	@$(RM) $(DIR)/*_crop.jpg
	@$(RM) $(DIR)/*.txt
	@$(RM) $(DIR)/*.csv

clean_final: severity
	@if [ -z $(DIR) ]; then echo "Need to run DIR=path" && exit 1; fi 	
	##@$(RM) $(DIR)/*_crop.jpg
	@$(RM) $(DIR)/*.txt
	@$(RM) $(DIR)/*areas*
