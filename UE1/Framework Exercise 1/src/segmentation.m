function foreground_map = segmentation(frames,FGScribbles,Hfc,Hbc,bins)
    
    % ============================
    % get dimension of our frames - should usually be (320 * 240 * 10)
    [yDim, xDim, zDim, ~]=size(frames);
    
    % ============================
    % We assume that the histogram is already normalized
    % therefor we simply copy it to another element
    nHfc = Hfc;
    nHbc = Hbc;

    %----------------------------------------------------------------------
    % Task c: Generate cost-volume
    %----------------------------------------------------------------------
    %{
        %Get the color-channels
        red = double(frames(:,:,1,:));
        green = frames(:,:,2,:);
        blue = double(frames(:,:,3,:));
        
        %normalize
        f=double(bins)/256.0;
        %calculate ID
        IDs=floor(double(red*f)) + floor(double(green)*f)*bins + floor(double(blue)*f)*bins*bins+1;
        size(IDs)
        size(red)
        pause;
        
        %calculate cost value
        cost = (nHfc(IDs)./(nHfc(IDs)+nHbc(IDs)));

        

        %figure;
        %imshow(cost>0.5);
        
        %find(isnan(cost))
        
        %%% TODO
        % cost ist jeweils nur 1 frame mit negativen & positiven werten
        % sollte allerdings eine 3d matrix sein mit >0.5 oder 0 als werte
        
        
        %set every not a number to zero
        cost(isnan(cost))=0;

    %}
    

    % ============================
    % Better performance if not done in loops - but it works this way ;)
    
    %create cost matrix - 3 dimensions (ySize, xSize, z=Frame Count)
    cost=ones(yDim, xDim, size(frames,4));
    
    %iterate over the (10) frames
    for i = 1:size(frames,4)    
        %normalize
        f=double(bins)/256.0;
        
        %calculate ID
        matrixPixelID = zeros(yDim, xDim, size(frames,4));
        %IDs=floor(double(red)*f) + floor(double(green)*f)*bins + floor(double(blue)*f)*bins*bins+1;
        
        matrixPixelID(:,:,i) = floor(double(frames(:,:,1,i))*f) + floor(double(frames(:,:,2,i))*f)*bins + floor(double(frames(:,:,3,i))*f)*bins*bins+1;
        
        
        %dirtcode powered by Michael - your professional dirt-coder
        for y = 1:yDim
           for x = 1:xDim
                %matrixPixelID(y,x,i) = floor(double(frames(y,x,1,i))*f) + floor(double(frames(y,x,2,i))*f)*bins + floor(double(frames(y,x,3,i))*f)*bins*bins+1;
                %nHfc(matrixPixelID(y,x,i))
                %nHbc(matrixPixelID(y,x,i))
                %pause;
                
                cost(y,x,i) = nHfc(matrixPixelID(y,x,i))/(nHfc(matrixPixelID(y,x,i))+nHbc(matrixPixelID(y,x,i)));
           end
        end
        
        cost
        pause;
        
        %dirtcode
        
        

        %figure;
        %imshow(cost>0.5);
        
        %find(isnan(cost))
        

    end
    
    
    
        cost
        pause;
        
    
    %set every not a number to zero
    cost(isnan(cost))=0;
    

    pause;
    
    %cost((cost<0.5))=0;    
        
    %----------------------------------------------------------------------
    % Task e: Filter cost-volume with guided filter
    %----------------------------------------------------------------------
    
    % -> FORUM: wie sind die skalarparameter r, rt, eps zu wählen?
    %
    seg = guidedfilter_vid_color(frames, cost, 1, 1, 5);
    %Threshold berücksichtigen oder so
%     fgIndizes = cost<0.5;
%     size(fgIndizes)
%     seg = seg(fgIndizes);
%     figure; imshow(seg(:,:,1))
    %----------------------------------------------------------------------
    % Task f: delete regions which are not connected to foreground scribble
    %----------------------------------------------------------------------
    seg_n = keepConnected(seg, FGScribbles);
    
    %----------------------------------------------------------------------
    % Task g: Guided feathering
    %----------------------------------------------------------------------
    foreground_map=guidedfilter_vid_color(frames, seg_n, 1, 1, 5);
    
end
