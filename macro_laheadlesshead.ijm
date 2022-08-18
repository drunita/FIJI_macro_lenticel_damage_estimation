	//------------------------macro externo------------------
	path = getArgument;
	if (path=="") exit ("No input image path given!");
	processFolder(path);
	
	function processFolder(path) {
		
		list = getFileList(path);
		for (i = 0; i < list.length; i++) {
			if(endsWith(list[i], ".jpg"))
				print(list[i]);
				path_to_file = path + "/" + list[i];
				runMacro("./macro_elbody.ijm", path_to_file);
							
		}
	}

	//------------------------macro externo------------------

