raw=getTitle();
folder=getInfo("image.directory");

run("Trainable Weka Segmentation");
selectWindow("Trainable Weka Segmentation v3.3.2");
wait(500)
call("trainableSegmentation.Weka_Segmentation.loadClassifier", "C:/Users/ls977/OneDrive - Yale University/DeCamilli Lab/classifier1234-1215-0712.model");

//waitForUser

call("trainableSegmentation.Weka_Segmentation.getResult");
rename("weka_"+raw);
save(folder+File.separator+getTitle());
