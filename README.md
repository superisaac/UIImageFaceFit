UIImageFaceFit 
========

UIImageFaceFit is a Objective-C Category that automatically detects
human faces in a image and fits faces to visible area to avoid being cliped by image borders.

## Install

* Drag Classes/UIImageFaceFit.h and Classes/UIImageFaceFit.m into your project 
* Added CoreImage framework build phases

## Example Usage

```
   self.imageView.clipsToBounds = YES;
   self.imageView.contentMode = UIViewContentModeScaleAspectFill;
   UIImage * originalImage = [UIImage imageNamed:@"origiinal.png"];
   self.imageView.image = [originalImage faceImageConstrainedToSize:self.imageView.frame.size];
```


