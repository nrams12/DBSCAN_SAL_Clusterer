# DBSCAN_SAL_Clusterer
DBSCAN to cluster Single-antibody labeling images. 

Written by Neal Ramseier
09.18.2025

To use this code, we assume you have an exported file from a ThunderSTORM image reconstruction. 

What you'll need:
1) Reconstructed ThunderSTORM export file.
2) A computer with a minimum of 16 GB RAM.
3) MATLAB installed on the computer.

Instructions:
1) Open the MATLAB code. We recommend running this code by each section rather than all at once.
2) Run the first section. The program will prompt the user to select the .csv file containing the dSTORM image data.
3) Prior to running the next section, set the minPTS (minimum number of points) and the Epsilon (radius) in the DBSCAN section of the code. These parameters may need adjusting depending on your data.
   It may require this section to be rerun until adequate clusters are achieved. The program then sorts all the clusters into a struct.
4) The next section exports the clustered data into a .csv file.
5) Program complete. 
