function [bok,scribble_count, fg_scribbles, histo_fg, histo_bg] = get_histograms(input_directory,file_list,bins)     
    % load reference frame and its foreground and background scribbles
    bok=false;
    scribble_count=0;
    reference_frame=[];
    fg_scribbles=[];
    histo_fg=[];
    histo_bg=[];
    for j = 1:numel(file_list)
        frame_name = file_list(j).name;

        if (strcmp(frame_name(1),'s') == 1) % scribble files begin with s
           frame = imread([input_directory '/' frame_name]); %read image      
           scribble_count=scribble_count +1;
           frames_scribbles(:,:,:,scribble_count) = frame(:,:,:);             
        elseif (strcmp(frame_name(1),'r') == 1) % reference file begin with r
           frame = imread([input_directory '/' frame_name]); % read image     
           reference_frame=uint8(frame(:,:,:));
        end
    end
    frames_scribbles=uint8(frames_scribbles);
   
    if ((scribble_count==2) && (~isempty(reference_frame))) 
        bok=true;
    else 
        return;
    end;
    
    %----------------------------------------------------------------------
    % Task a: Filter user scribbles to indicate foreground and background   
    %----------------------------------------------------------------------
    
    % ============================
    % create empty binary images for the background and foreground
    bgBinary = 0;
    fgBinary = 0;
    
    % ============================
    % fill the binary images with the scribble
    % absolute difference between each channel is calculated and connected
    % with logical OR
    bgBinary = abs(reference_frame(:,:,1)-frames_scribbles(:,:,1,2)) | abs(reference_frame(:,:,2)-frames_scribbles(:,:,2,2)) | abs(reference_frame(:,:,3)-frames_scribbles(:,:,3,2));
    fgBinary = abs(reference_frame(:,:,1)-frames_scribbles(:,:,1,1)) | abs(reference_frame(:,:,2)-frames_scribbles(:,:,2,1)) | abs(reference_frame(:,:,3)-frames_scribbles(:,:,3,1));
    
    %----------------------------------------------------------------------
    % Task b: Generate color models for foreground and background
    %----------------------------------------------------------------------
    fg_scribbles = fgBinary;
    
    % ============================
    % Split reference frame into 3 RGB channels
    redo = reference_frame(:,:,1);
    blueo = reference_frame(:,:,2);
    greeno = reference_frame(:,:,3);
    
    % ============================
    % create a color histogram by calling "colHist" for both back and
    % foreground, using 
    red = redo(bgBinary);
    blue = blueo(bgBinary);
    green = greeno(bgBinary);
    histo_bg = colHist(red, blue, green, bins);

    red = redo(fgBinary);
    blue = blueo(fgBinary);
    green = greeno(fgBinary);
    histo_fg = colHist(red, blue, green, bins);
    
end