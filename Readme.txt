
====================================================================================================================================
*****************Implementation of Paper "Multioriented Video Scene Text Detection Through Bayesian Classification and Boundary Growing" written by 
Palaiahnakote Shivakumara, Rushi Padhuman Sreedhar, Trung Quy Phan, Shijian Lu, and Chew Lim Tan, Senior Member, IEEE************* 
====================================================================================================================================

The folder contains:

1.gui1.fig  ( The gui design)
2.gui1.m    (The main file )
3.Plain_program.m (The code without gui)
4.regiongrowing.m (Function script)
5.uiselectim.m (Function script)
6.Samplevideo.avi (Video file)
7.Sample Images (Folder with 8 sample images of different orientation)
8.Base Paper 

BEFORE YOU RUN THIS CODE
====================================================================================================================================
Dependencies:

1. Windows XP or higher version of OS
2. Install MATLAB 7.11.0 or higher version with Image Processing toolbox Installed in it.
3. The following files should be there in  the toolbox.

toolbox             :  \images\images\imabsdiff.m
toolbox             :  \rtw\targets\common\tgtcommon\private\int2str.p
toolbox             :  \curvefit\cftoolgui\private\im2uint8.m
toolbox             :  \images\images\bwboundaries.m
toolbox             :  \images\images\bwlabel.m
toolbox             :  \images\images\edge.m
toolbox             :  \images\images\fspecial.m
toolbox             :  \images\images\im2bw.m
toolbox             :  \images\images\imcomplement.m
toolbox             :  \images\images\imfilter.m
toolbox             :  \images\images\immultiply.m
toolbox             :  \images\images\label2rgb.m
toolbox             :  \images\images\regionprops.m
toolbox             :  \images\images\rgb2gray.m
toolbox             :  \images\imuitools\getimage.m
toolbox             :  \images\imuitools\imshow.m
toolbox             :  \stats\stats\kmeans.m
toolbox             :  \images\imuitools\imshow.m
toolbox             :  \images\imuitools\imshow.m



TO BUILD AND  RUN THIS CODE
================================================================================================================================================
1. Traverse the MATLAB path to current directory through Matlab commandline or through Matlab Editor.
2. Run "gui1.m"
3. Click "Load Image" Button to select and load the image and click on "Processing" button
4. Wait for the text to get extracted
5. On clicking "Load video" button, the selected video is divided into individual frames and are stored in "Video Frames" folder in current directory
and keyframes in "Keyframes" directory.(This process is very slow and may take more than 2 minutes)
6. To calculate the execution time using "Profiler" tool in matlab, run "Plain_program.m" by specifying the input image in first line of the file 
================================================================================================================================================


NOTE
================================================================================================================================================
1. Workspace variables after execution of "Plain_program.m" gives more idea about analysis.
2. API'S can be clearly understood by using "Function Browser" in Matlab or by studying in Help Manual of Matlab
3. Project can be further implemented for "TEXT RECOGNITION"
4. Apart from the paper, "regiongrowing" is implemented instead of "Boundary growing". Details are in "regiongrowing.m"
5. Regiongrowing works relatively slow compared to "Boundary Growing" but succeeds in identifying true positives
 ================================================================================================================================================