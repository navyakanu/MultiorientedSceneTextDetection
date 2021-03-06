%%***************** Implementation of Paper "Multioriented Video Scene Text
%% Detection Through Bayesian Classification and Boundary Growing" written by 
%%Palaiahnakote Shivakumara, Rushi Padhuman Sreedhar, Trung Quy Phan, Shijian Lu,
%% and Chew Lim Tan, Senior Member, IEEE************* 
% Dependencies: FROM IMAGE PROCESSING TOOLBOX
% toolbox             :  \curvefit\cftoolgui\private\im2uint8.m
% toolbox             :  \images\images\bwboundaries.m
% toolbox             :  \images\images\edge.m
% toolbox             :  \images\images\fspecial.m
% toolbox             :  \images\images\im2bw.m
% toolbox             :  \images\images\imcomplement.m
% toolbox             :  \images\images\imfilter.m
% toolbox             :  \images\images\immultiply.m
% toolbox             :  \images\images\imresize.m
% toolbox             :  \images\images\label2rgb.m
% toolbox             :  \images\images\rgb2gray.m
% toolbox             :  \images\imuitools\imshow.m
% toolbox             :  \stats\stats\kmeans.m
% Refer workspace for more analysis
% MATLAB 7.11.0 or higher or lower version with all dependency files

%% Profiler time for best case image : 2 second
%% Profiler time for worst case image : 8 second

I=imread('18.jpg');                          %% Input image name 
%%I=imresize(I, [100 NaN]);                    %% Resize any image to 100 rows image
i=rgb2gray(I);                               %% Convert from rgb to gray image

     h=fspecial('laplacian');                %% laplacian filter
     H=imfilter(i,h);
     h1=fspecial('sobel');                   %% Apply sobel
                                             %% Horizontal filter by default
     HS=imfilter(i,h1);
     h2=fspecial('average',5);               %% Kernel size 5 for avaeraging filter
     HS5=imfilter(HS,h2);
     LSF=immultiply(H,HS5);                  %% Maask image formed by the multiplication of pure laplacian and filtered sobel
     %% figure(9);
     % imshow(LSF); title('LSP');
 
     out=i+LSF;                              %% Sharpened image formed by the sum of base image and LSP mask

     gamma=1;                                %%Power law transformation
     final=out.^gamma;                       %%Final preprocessed image

 
     
%%*************** Constructing 3 probable matrix for classification based on unsupervised learning using k-means
                                 
                                
     HLSP=im2bw(final,0.5);                  %%1 matrix HLSP, threshholding the image based on contrast
     HLSP=imcomplement(HLSP);                %% Text pixel 1, non text 0 Refer workspace
     %%figure(12);
     %%imshow(HLSP), title('HLSP');
 
     
     
      ab1 = double(out);                       %%2nd Matrix K-LSP, k-means on HLSP
      nrows1 = size(ab1,1);
      ncols1 = size(ab1,2);
      ab1 = reshape(ab1,nrows1*ncols1,1);      %% Change matrix to 1-D array for kmeans API input
 
 
      nColors1 = 2;                             % repeat the clustering 2 times to avoid local minima
      
      [cluster_idx1 cluster_center1] = kmeans(ab1,nColors1,'distance','sqEuclidean','emptyAction','drop', ...
          'Replicates',2);
      pixel_labels1 = reshape(cluster_idx1,nrows1,ncols1);
      pixel_labels2=pixel_labels1;
      
      %pixel_labels1=im2bw(pixel_labels1,0.5);
      pixel_labels1=pixel_labels1-1;         %% Small math to change label from 2 and 1 to 1 and 0
      pixel_labels1=imcomplement(pixel_labels1);
      
      %figure(16);
      %imshow(pixel_labels1,[]), title('image labeled by cluster index, KLSP');
     
     
     
        
     %figure(13);
     %imhist(HLSP), title('HLSP');
 
                                  
     ab = double(HLSP);                      %%3rd Matrix K-MGD-HLSP, kmeans on Maximum gradient difference on HLSP
     nrows = size(ab,1);
     ncols = size(ab,2);
     ab = reshape(ab,nrows*ncols,1);         
 
     nColors = 2;                            % repeat the clustering 2 times to avoid local minima 
                                                              
     [cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','emptyAction','singleton', ... 
         'Replicates',2); 
     pixel_labels = reshape(cluster_idx,nrows,ncols);
     pixel_labels=pixel_labels-1;              %% Small math to change label from 2 and 1 to 1 and 0
     pixel_labels=imcomplement(pixel_labels);
     
 
  
                                        
                                           %%MGD
     [rows, columns] = size(LSF);          %% Traverse a 3x3 window on HLSP, find difference of Maximum and minimum value and replace with that value

        h=0; l=0; diff=0; px1=0; x=0; y=0; ct=0;
        px=(rows*columns);
        for x=1:x+3:rows-2
            for y=1:columns-2
                for r=x:x+2
                    for c=y:y+2
                        px1=pixel_labels(r,c); 
                            if px1>h
                                h=px1;
                            end
                            if px1<l
                                l=px1;
                            end 
                    end
                end
                diff=h-l;
                for r=x:x+2
                    for c=y:y+2
                        px(r,c)=diff;
                            ct=r;
                    end
                end  
            h=l; l=h;
            end
        end

            if r<rows
                for r=ct:rows
                    for c=1:columns
                     px(r,c)=0;
                    end
                end
            end

        px=im2bw(px,0.5);
            %px=imcomplement(px);
            %figure(18);
            %imshow(px), title('image labeled by cluster index, KMGDHLSP');




%%*********************Bayesian Classification calculating Priory and posterior probability
            pixel_labels1=logical(pixel_labels1); 
            bc=(rows*columns); %% BC Bayes classmatrix
            nWhite = nnz(LSF); %% Non zero matrix in Laplacian sobel product
            nop=rows*columns;


            pt=nWhite;         %% Probability of text pixels
            pnt=(nop-nWhite);  %% Probablity of non text pixels

            %pt=nWhite/nop;
            %pnt=(nop-nWhite)/nop;

        NLSF=imcomplement(HLSP);  %% 3 conditional non probability matrix comlpimenting probability matrix
        NKLSP=imcomplement(pixel_labels1);
        NMGD=imcomplement(px);

%% *********************Applying Bayesian Model*****************************
    for r=1:rows
        for c=1:columns
            pxyt=(HLSP(r,c)+pixel_labels1(r,c)+px(r,c))/3;
            pnxyt=(NLSF(r,c)+NKLSP(r,c)+NMGD(r,c))/3;

            ptxy=(pxyt*pt)/((pxyt*pt)+(pnxyt*pnt));
            if ptxy>=0.5                                %% Decision Based on Threshhold
                bc(r,c)=1;
            else
                 bc(r,c)=0;
            end
        end
    end


%figure(20);
%imshow(bc), title('image labeled by cluster index, bc');
 



%%*********************Segmentation through edge detection************


        C1=edge(bc,'canny',0.5);   %% Apply canny edge detection with threshhold 
        C2=im2uint8(C1);


%%*********************Boundary growing*********************************


  x=2; y=2;
        J = regiongrowing(C1,x,y,0.2); 
        figure(13), imshow(J), title('Text detection');
  
 %%**************** TEXT EXTRACTION AND RECOGNITION CAN BE CARRIED 
 

   
 
                                                         
 [L Ne]=bwlabel(C1);                         %%Bounding box for detected text     
% %imshow(L==n);
%                                             %% Measure properties of image regions using regionprops
     propied=regionprops(L,'BoundingBox');
     hold on
                                             %% Plot Bounding Box
         for n=1:size(propied,1)
              rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
         end
     hold off
   sum=5000;
     sum=0;

    
    
 %%***************** False positive elimination with text extraction*********************
 %% Calculating WIDTH, HEIGHT , EDGE AND ASPECT RATIO OF TEXTS 
 %% Deciding based on the following parameters
 %%*** Pending
    
[rows, columns] = size(bc);
        for r=1:rows
            for c=1:columns
                sum=sum+bc(r,c);

            end
        end


        EA=sum;
        ph=500;

        imgs3 = cell(5,1);  
            for pt=1:Ne                                                    %% Loop equal to the number of bounding box

                [r,c] = find(L==pt);                                       %% Find indiviadual boxes and display
                n1=C2(min(r):max(r),min(c):max(c));
                [W H ]=size(n1);                                           %% Measure width and height of bounding box
                AR=(W/H);                                                  %%Find aspect ratio
                A=W*H;                                                     %% Find area
                ratio=(EA/A);
                    if (AR>0.5&&ratio>1)                                   %% Conditions for true positives
                        if(size(n1)>20)
        
                        figure(ph), imshow(n1,[]), title('Extracted Character');   %% Display image
       

            ph=ph+1;
                        end
                    end
            end


   

%%********************** Recognition can be continues with Neural
%%Networks or other classifiers*****

 
 
 
 