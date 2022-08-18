
macro "macro_elbody" {
	path_to_file = getArgument();
	print(path_to_file);
	processFile(path_to_file);
	exit();
}

function closeWindow(name) {
  selectWindow(name);
  close();
}

function adjustThresholdOnOpenImage(title, min, max) {

	hue = "Hue";
	saturation = "Saturation";
	brightness = "Brightness";
	image_properties = newArray(hue, saturation, brightness);

	run("Duplicate...", " ");
	run("HSB Stack");
	run("Convert Stack to Images");

	for (i = 0; i < image_properties.length; i++){
		selectWindow(image_properties[i]);
		setThreshold(min[i], max[i]);
		run("Convert to Mask");
	}

	imageCalculator("AND create", hue, saturation);
  	imageCalculator("AND create", "Result of " + hue, brightness);

	for (i = 0; i < image_properties.length; i++){
		closeWindow(image_properties[i]);
	}

	closeWindow("Result of " + hue);

	selectWindow("Result of Result of " + hue);
	rename(title);
}

function processFile(path_to_file) {
//------------Star croping image---------------------------------
	directory = File.getParent(path_to_file) + "/"; // Directorio de la imagen
	image_file = File.getName(path_to_file); // Nombre de la imagen con extension
	open(path_to_file);
	title = getTitle();
	print(title);
	image_name = File.nameWithoutExtension; // Nombre de la imagen sin extension (foto abierta, después de open(path);)
	print(image_name);
	output_individual_areas= directory + image_name + "_areas_ind.csv";
	output_tota_area = directory + image_name + "_areas_tot.csv";
	output_mask = directory + image_name + "_bitmask.jpg";
	output_error = directory + image_name + ".txt";
	output_imagen_path = directory + image_name + ".txt";
	crop_imagen = directory + image_name + "_crop.jpg";

	min=newArray(5, 0, 0);// parametros nomales
	max=newArray(255, 255, 170); // parametros nomales
	min=newArray(5, 40, 0);

   	adjustThresholdOnOpenImage(title, min, max);

 	run("Analyze Particles...", "size=200000-Infinity circularity=0.15-1.0 show=[Overlay] include record");

 	if (Overlay.size != 1) {
    	file = File.open(output_error);
   		msg="Su imagen no fue leida, posiblemente por la calidad de la imagen. Asegurece de estar usando el formato requerido";
    	File.append(msg, output_error);
//		eval("script", "System.exit(1);");
		run("Close");
		selectWindow(title);
		run("Close");
		exit();
	}

	selectWindow(title);
	run("Images to Stack", "name=Stack title=[] use keep");
	run("Next Slice [>]");

	for (blob = 0; blob < Overlay.size; blob++){
		Overlay.activateSelection(blob);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside", "stack");

	}

	run("Previous Slice [<]");
	saveAs("Jpeg", crop_imagen);
	run("Close");
	selectWindow(title);
	run("Close");
	selectWindow(title);
	run("Close");

//------------End croping image---------------------------------
//------------Star area total---------------------------------

	open(crop_imagen);
	title = getTitle();

		min=newArray(5, 0, 0);
		max=newArray(255, 255, 170);
	//Imagenes caro
		//max=newArray(255, 255, 250);
	adjustThresholdOnOpenImage(title, min, max);


	run("Analyze Particles...", "size=20000-Infinity circularity=0.1-1.0 show=[Overlay Masks] exclude include record");
	run("Fill Holes");

	if (Overlay.size != 1) {
    	file = File.open(output_error);
   		msg="Su imagen no fue leida, posiblemente por la calidad de la imagen. Asegurece de estar usando el formato requerido";
    	File.append(msg, output_error);
//		eval("script", "System.exit(1);");
		exit();
	}
	ablobs=Overlay.measure;
	saveAs("Results", output_tota_area);
	saveAs("Jpeg", output_mask);
	Overlay.clear;
	selectWindow(title);
	run("Close");
	selectWindow(title);
	run("Close");

//------------End area total---------------------------------
//------------Star area individual---------------------------------
	open(crop_imagen);
	title = getTitle();

		min=newArray(1, 0, 5);
		max=newArray(50, 250, 75);
		//max=newArray(35, 250,255);
	adjustThresholdOnOpenImage(title, min, max);


	//run("Analyze Particles...", "size=40-50500 circularity=0.05-1.0 show=[Overlay Masks] exclude include record");
	run("Analyze Particles...", "size=65-308000 circularity=0.02-1.0 show=[Overlay Masks] exclude include record");
	run("Fill Holes");
	ablobs=Overlay.measure;

	saveAs("Results", output_individual_areas);
	saveAs("Jpeg", output_mask);
	file = File.open(output_imagen_path);
   	File.append(output_imagen_path, output_imagen_path);
	Overlay.clear;
	selectWindow(title);
	run("Close");
	selectWindow(title);
	run("Close");
}

