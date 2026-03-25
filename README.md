# SF-Coyote-Endocrine

This repository contains all raw data and scripts for the data analysis implemented in XXXX et al. (XXXX) titled: *Stress and thyroid hormones covary with urban intensity and diet in coyotes (Canis latrans)* and published in XXXXX.

Please find below a description of all raw and clean data sets and the scripts used to clean the raw data, run the models, and create the figures presented in the manuscript.

## Data Files

In the `Data` folder, you will find a number of data files required for the analyses completed in this study.

`Hormone_Data.csv`: hormone metabolite concentration data.

| Column | Description |
|------------------------------------|------------------------------------|
| Code | Unique identifier used by endocrine lab |
| Collector | Initials of person who collected the sample in the field |
| Number | Field ID sample number |
| Date | Date of sample collection |
| Bag | Bag number sample was shipped in |
| T3 | T3 concentration (ng/g); *NA* values indicate missing values (no data recorded) |
| T4 | T4 concentration (ng/g); *NA* values indicate missing values (no data recorded) |
| GC | GC concentration (ng/g); *NA* values indicate missing values (no data recorded) |

`All_Metadata.csv`: sample metadata and species identification.

| Column | Description |
|------------------------------------|------------------------------------|
| SampleID | Unique identifier for DNA sample |
| Replicate | Indicates whether the sample was a replicate extraction or not |
| FieldID | Unique identifier for the sample when collected in the field |
| Site | Site code for location sample was collected |
| Area | Indicates whether sample was collected in urban or nonurban region |
| Initials | Initials of person who collected the sample in the field |
| Year | Year sample was collected |
| Month | Month sample was collected |
| Day | Day sample was collected |
| Condition | Condition of sample at time of collection |
| Lat | Latitude; *NA* values indicate missing location data |
| Long | Longitude; *NA* values indicate missing location data |
| Geno.Sp | Species identification from genotyping; *NA* values indicate sample was not genotyped |
| Cytb_Sp | Species identification from Cytochrome b analysis; *NA* values indicate Cytochrome b analyses were not performed on sample |

`Individual_IDs.csv`: individual identification.

| Column     | Description                                       |
|------------|---------------------------------------------------|
| SampleID   | Unique identifier for DNA Sample                  |
| Individual | Label for individual coyote sample is assigned to |

`Family_Data.csv`: sex and breeding status information.

| Column | Description |
|------------------------------------|------------------------------------|
| Individual | Label for individual coyote sample is assigned to |
| Sex | Sex of individual |
| Breeder | Indicates whether or not individual is a breeder or non-breeder |

`func.RRA.clean.csv`: diet metabarcoding data from Caspi *et al.* (2025) published in *Ecosphere* (doi: 10.1002/ecs2.70152).

| Column         | Description                                           |
|----------------|-------------------------------------------------------|
| SampleID       | Unique identifier for DNA Sample                      |
| Anthropogenic  | Relative read abundance of diet category in each scat |
| Bird           | Relative read abundance of diet category in each scat |
| Herpetofauna   | Relative read abundance of diet category in each scat |
| Marine.Aquatic | Relative read abundance of diet category in each scat |
| Medium.Mammal  | Relative read abundance of diet category in each scat |
| Small.Mammal   | Relative read abundance of diet category in each scat |

## Scripts

The scripts for the full workflow are available as R and Rmd files in the `Code` folder. All files are R scripts that were run in R version 4.2.1.

-   `Clean_Data.Rmd`: this script takes the raw hormone data and cleans and formats the data for statistical analyses and data visualization.

-   `Correlations.R`: this script assesses the strength and significance of the correlation between each pair of hormones.

-   `GLMMs.Rmd`: the script uses the *brms* package to construct generalized linear mixed effect models that assess the effect of diet, impervious surface cover, and life history covariates on hormone metabolite concentrations. The script also constructs table of model output, calculates repeatabilities for random effects, computes average marginal contrasts and performs post-hoc tests for pairwise comparisons, and constructs plots to visualize model results.

-   `Study_Site_Map.R`: this script generates the study site sample collection map.

-   `ISA_Coyote_Scats.Rmd`: this script calculates the proportion of impervious surface cover in a buffer surrounding each scat collection location. Running this script requires downloading the associated impervious surface raster from <https://www.mrlc.gov/data>.

## Cleaned Data

In the `Cleaned_Data` folder, you will find a number of cleaned up files that are generated within some of the R scripts contained in the `Code` folder (described below). These cleaned data files are required in some of scripts.

Cleaned raw data:

-   `clean_hormone_genotypes_diet.csv`: output of `Clean_Data.Rmd` script

-   `scat_level_isa.csv`: output of `ISA_Coyote_Scats.Rmd` script

## Model Output

The output of the models can be generated on your own device or are available to download from within the `Model_Output` folder.

-   `mod.GC.rds`, `mod.T3.rds`, `mod.T4.rds`, and `mod.interact.rds`: model output for the GLMMs assessing the effects of diet, impervious surface cover, and life history traits on fecal hormone metabolite concentrations.

-   `mod.corr.GC.T3.rds`, `mod.corr.GC.T4.rds`, and `mod.corr.T4.T3.rds`: model output for models assessing associations between each pair of hormones.

## Figures

In the `Figures` folder you will find all .png files for figures in the manuscript, which are generated by the scripts above.
