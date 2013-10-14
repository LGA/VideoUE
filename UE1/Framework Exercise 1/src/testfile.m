reference_frame = uint8(imread('..\fg_frames\rframe-00339.png'));
frames_scribbles(:,:,:,1) = imread('..\fg_frames\sframe-00339.png');
frames_scribbles(:,:,:,2) = imread('..\fg_frames\ssframe-00339.png');
bgBinary = 0;
fgBinary = 0;
bgBinary = abs(reference_frame(:,:,1)-frames_scribbles(:,:,1,2)) | abs(reference_frame(:,:,2)-frames_scribbles(:,:,2,2)) | abs(reference_frame(:,:,3)-frames_scribbles(:,:,3,2));
fgBinary = abs(reference_frame(:,:,1)-frames_scribbles(:,:,1,1)) | abs(reference_frame(:,:,2)-frames_scribbles(:,:,2,1)) | abs(reference_frame(:,:,3)-frames_scribbles(:,:,3,1));
figure; image(fgBinary);

red = reference_frame(:,:,1);
blue = reference_frame(:,:,2);
green = reference_frame(:,:,3);
red = red(bgBinary);
blue = blue(bgBinary);
green = green(bgBinary);
test = colHist(red, blue, green, 16);

red = reference_frame(:,:,1);
blue = reference_frame(:,:,2);
green = reference_frame(:,:,3);
red = red(fgBinary);
blue = blue(fgBinary);
green = green(fgBinary);
test2 = colHist(red, blue, green, 16);