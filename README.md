# tubule-v-vesicle

1. A segmentation model, contained in the file `classifier1234-1215-0712.model`, was trained via the FIJI's Trainable Weka Segmentation plugin. 
2. For each rhodamine-liposome input image, the ImageJ script `Macro1.ijm is` called to apply the model and obtain a segmentation result, saved in the same folder as the input image with `weka_` preceding thhe input file's name, which segments the image into the background, tubules, and vesicles.
3. After that, the MATLAB script `pick_tubule.m` is run to refine the tubule selection base on morphological criteria and reassign false tubule objects into vesicles. 
4. Ratio between the total area of the tubules and the sum of that and the total area of the vesicles is then calculated by the same script and the results are appended to a CSV file located in the same folder as the input image, with each line corresponding to a different input image that has been analyzed.
