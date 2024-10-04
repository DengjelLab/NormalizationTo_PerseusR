# NormalizationTo_PerseusR
R script to use with Perseus software  

The script does a median or mean normalization per column as Perseus software, but moves the values back to the original scale range avoiding negative values.  
It exist for working in linear data scale and log scale - choose the correct script depending on your data.


<p align="center">
  <img src="/assets/norm_1.png" width="60%"/>
</p>

Add "mean" and/or "median" as additional argument in Perseus software.  

<p align="center">
  <img src="/assets/norm_2.png"/>
</p>

Beside a normalization to the mean or median, a sum normalization is available (useful for TMT experiments, only meaningful in linear data scale) and normalization to a specific protein.

