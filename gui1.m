%%***************** Implementation of Paper "Multioriented Video Scene Text
%% Detection Through Bayesian Classification and Boundary Growing" written by 
%%Palaiahnakote Shivakumara, Rushi Padhuman Sreedhar, Trung Quy Phan, Shijian Lu,
%% and Chew Lim Tan, Senior Member, IEEE************* 
% Execution time for 1 frame =2 seconds (Best case)
%%                            8 seconds (Worst case)


function varargout = gui1(varargin)


clc;

% GUI1 M-file for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1

% Last Modified by GUIDE v2.5 01-Mar-2013 15:46:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)

% Choose default command line output for gui1
  




handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname,filterindex]=uigetfile('*','pick a file');

vid=[pathname,filename];
readerobj = mmreader(vid);

%get number of frames

    numFrames = get(readerobj, 'numberOfFrames');
    mkdir('Video frames');                              %% Create directory to store frames
            for k = 1 : numFrames
                vidFrames = read(readerobj,k);
                    %mov(k).cdata = vidFrames(:,:,:,k);
                mov(k).cdata = vidFrames;
                mov(k).colormap = [];
                %imshow(mov(k).cdata);
                imagename=strcat(int2str(k), '.jpg');               %% Store images in .jpg format
   
                %save inside output folder
                imwrite(mov(k).cdata, strcat('Video frames\',imagename));
            end
    
    
                obj=mmreader(vid);
                numFrames = get(obj, 'numberOfFrames');
                mkdir('Keyframes');
                k=1;
                v1 = read(obj,1);
                mov(k).cdata = v1;
                mov(k).colormap = [];
                %imshow(mov(k).cdata);
                imagename=strcat(int2str(k), '.jpg');
   
                %save inside output folder
                imwrite(mov(k).cdata, strcat('Keyframes\',imagename));  
   
    
            for k=2:numFrames
                v1 = read(obj,k);
                f=0;
                for k1=1:k-1
                    v2 = read(obj,k1);
                    mm=imabsdiff(v1,v2);  
                        if any(mm)
                            f=0;
                        else
                             f=1; break;
                        end
                end
                    if f==0
                        mov(k).cdata = v1;
                        mov(k).colormap = [];
                                                     %imshow(mov(k).cdata);
                        imagename=strcat(int2str(k), '.jpg');
   
                        %save inside output folder
                        imwrite(mov(k).cdata, strcat('Keyframes\',imagename));
    
                    end
                    pause(10);
            end
           
            disp('Video frames extracted and Keyframes are stored in Keyframes folder')


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%LSP
handlelsp=@LSPCALL;
handlelsp(); 


        
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



    

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





    

function LSPCALL(varargin)
%%******************Read image from file
   
    I=getimage();                            %% Read image frame       
                
 %% ********Implementation of Image Enhancement wrt DIP by Gonzlvez 3rd edition "Compination of different Spatial filters", Chapter 3
     
     i=rgb2gray(I);                          %% Convert from rgb to gray image
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
 
%%********************Gallery display for images of preprocessing step
        
        
        
imgs1 = cell(7,1);        %% Store 8 images in an aarray
 
 imgs1{1}=i;              %% RGB IMAGE
 imgs1{2}=H;              %% Laplacian
 imgs1{3}=HS;             %% Sobel
 imgs1{4}=HS5;            %% Averaging filter
 imgs1{5}=LSF;            %% LSP
 imgs1{6}=out;            %% INPUT+LSPMASK
 imgs1{7}=final;          %% LSP + GAMMA TRANSFORM

 
str={'Gray image','Laplacian','Sobel','Averaging filter','LSP','Input+Lspmask','Final preprocessed image'};

    %# show them in subplots
    figure(11)
    for i=1:7
        subplot(3,3,i);
        h = imshow(imgs1{i}, 'InitialMag',100, 'Border','tight');
        title(str(i))
        set(h, 'ButtonDownFcn',{@callback,i,imgs1})
    end
    

%%********************Gallery display for images of preprocessing step
        

        imgs2 = cell(5,1);
 
        imgs2{1}=HLSP;
        imgs2{2}=pixel_labels1;
        imgs2{3}=px;
        imgs2{4}=bc;
        imgs2{5}=C1;
 
 str1={'HLSP','KLSP','KMGDHLSP','BC','CANNY'}; 


 
  figure(12)
    for i=1:5
        subplot(2,3,i);
        h = imshow(imgs2{i}, 'InitialMag',100, 'Border','tight');
        title(str1(i))
        set(h, 'ButtonDownFcn',{@callback,i,imgs2})
    end
   

%%****************** Region growing to traverse boundary of the text
%%figure(300), imshow(C2), title('input image');
       
       x=2; y=2;
         J = regiongrowing(C1,x,y,0.2); 
         figure(13), imshow(J), title('Text detection');







  
  
                                                         
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

   

%%*************** Mouse click handling for gallery display images
    % mouse-click callback function
    function callback(o,e,idx,imgsdx)
        %% show selected image in a new figure
        figure(100), imshow(imgsdx{idx})
        
    
   
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%BC
 


        


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgaxes1=uiselectim;
axes(handles.axes3);
imshow(imgaxes1);
