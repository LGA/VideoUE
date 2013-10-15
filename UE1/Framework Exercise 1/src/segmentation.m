function foreground_map = segmentation(frames,FGScribbles,Hfc,Hbc,bins)
    
    [yDim, xDim, zDim, ~]=size(frames);
    
    %Normalize
    %nHfc = Hfc / (yDim * xDim * 3);
    %nHbc = Hbc / (yDim * xDim * 3);

    %Annahme: cost ist bereits normalisiert
    % --> Frage ins Forum
%     nHfc = repmat(Hfc, [yDim xDim zDim]);
%     nHbc = repmat(Hbc, [yDim xDim zDim]);
    
%     nHfc = zeros(yDim, xDim, zDim);
%     nHfc = nHfc + Hfc;

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
    

    cost=ones(yDim, xDim, size(frames,4));
    
    for i = 1:size(frames,4)
        %Get the color-channels
%         red = double(frames(:,:,1,i));
%         green = double(frames(:,:,2,i));
%         blue = double(frames(:,:,3,i));
%         
        %normalize
        f=double(bins)/256.0;
        %calculate ID
        matrixPixelID = zeros(yDim, xDim, size(frames,4));
        %IDs=floor(double(red)*f) + floor(double(green)*f)*bins + floor(double(blue)*f)*bins*bins+1;
        
        %dirtcode powered by Michael - your professional dirt-coder
        for y = 1:yDim
           for x = 1:xDim
                matrixPixelID(y,x,i) = floor(double(frames(y,x,1,i))*f) + floor(double(frames(y,x,2,i))*f)*bins + floor(double(frames(y,x,3,i))*f)*bins*bins+1;
                cost(y,x,i) = nHfc(matrixPixelID(y,x,i))/(nHfc(matrixPixelID(y,x,i))+nHbc(matrixPixelID(y,x,i)));
           end
        end
        
        %dirtcode
        
%         size(IDs)
%         size(cost)
%         size(nHfc)
%         size(nHbc)
%         size((nHfc(IDs)/(nHfc(IDs)+nHbc(IDs))))
        
        
        
        %calculate cost value
%       cost(i) = (nHfc(IDs)/(nHfc(IDs)+nHbc(IDs)));
%         size(cost)
%         pause;
        

        %figure;
        %imshow(cost>0.5);
        
        %find(isnan(cost))
        

    end
    
    %set every not a number to zero
    cost(isnan(cost))=0;
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
