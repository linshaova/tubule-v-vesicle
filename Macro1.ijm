raw=getTitle();
folder=getInfo("image.directory");

run("Trainable Weka Segmentation");
selectWindow("Trainable Weka Segmentation v3.3.2");

// Otherwise the next call(...) would fail half of the time:
wait(500)

call("trainableSegmentation.Weka_Segmentation.loadClassifier", "classifier1234-1215-0712.model");

call("trainableSegmentation.Weka_Segmentation.getResult");
rename("weka_"+raw);
save(folder+File.separator+getTitle());
