# NormalizationTo_PerseusR
R script to use with Perseus software  

The script does a median or mean normalization per column as Perseus software, but moves the values back to the original scale range avoiding negative values.  
It exist for working in linear data space and log space - choose the correct script depending on your data.

<p align="center">
  <img src="/assets/norm_1.png" width="60%"/>
</p>

Add "mean" and/or "median" as additional argument in Perseus software.  
Beside a normalization to the mean or median, a sum normalization is possible (useful for TMT experiments, only meaningful in linear data space) and normalization to a specific protein

