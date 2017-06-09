function [patches_preproc, images, labels] = preprocess(params, imagedir, labeldir,range, testing)
    %%Loading Images
    imagefiles = dir(strcat(imagedir,'*.tiff'));     
    labelfiles = dir(strcat(labeldir,'*.tif'));
    nfiles = length(imagefiles);    % Number of files found
    if range==0
        range= nfiles;
    end
    
    d = 2;  
    sigma = [3 0.1];
    images= [];
    VsR = [];
    VsG = [];
    VsB = [];
    Vs= [];
    labels = [];
    for i=1:range
        currentfilename = imagefiles(i).name;
        currentlabelname = labelfiles(i).name;
        currentlabel = imread(strcat(labeldir, currentlabelname));
        
        
        if(params.rfSize(3)==1)
            currentimage = rgb2gray(imread(strcat(imagedir, currentfilename)));
        else
            currentimage = imread(strcat(imagedir, currentfilename));
        end
        labels(:,:,i) =double (currentlabel(:,:,1) > 0);
        
        % Gaussian Pyramid of the image, saved in a vector
        % V{i} is a cell array each of which is a scaled image in the pyramid
        pyr = pyramid(currentimage, params);
        Vs= [Vs; pyr]; 
        
        if(params.rfSize(3)>1)
            VsR = [VsR; pyr(1:params.numscales, :)];
            VsG = [VsG; pyr(params.numscales+1:params.numscales*2, :)];
            VsB = [VsB; pyr(params.numscales*2+1:end, :)];
        end
        
        %imshow(pyr{1});
        %pause
        clear currentimage;
        clear pyr;
    end
    
    if(params.rfSize(3)>1)
        images = [VsR; VsG; VsB];
    else
        images= Vs;
    end
    clear Vs;

   % Extract Patches from the Gaussian Pyramid
   if testing==0
     patches = extract_patches_building(images, params);
     patches_preproc= zcawhitening(patches, params);
   else
       patches_preproc= [];
   end
   
    
   
end
