# SF-Coyote-Endocrine

This repository contains all raw data, plots and scripts for the data analysis implemented in Caspi et al. (XXXX) titled: *Coordinated stress and metabolic responses may facilitate coyote persistence in cities* and published in XXXXX.

Please find below a description of all raw and clean data sets and the scripts used to clean the raw data, run the models, and create the figures presented in the manuscript.

## Data Files

In the `Data` folder, you will find a number of files:

`Hormone_Data.csv`

| Column    | Description                                              |
|-----------|----------------------------------------------------------|
| Code      | Unique identifier used by endocrine lab                  |
| Collector | Initials of person who collected the sample in the field |
| Number    | Field ID sample number                                   |
| Date      | Date of sample collection                                |
| Bag       | Bag number sample was shipped in                         |
| T3        | T3 concentration (ng/g)                                  |
| T4        | T4 concentration (ng/g)                                  |
| GC        | GC concentration (ng/g)                                  |

`All_Metadata.csv`

| Column | Description |
|-----------------|-------------------------------------------------------|
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
| Lat | Latitude |
| Long | Longitude |
| Geno.Sp | Species identification from genotyping |
| Cytb_Sp | Species identification from Cytochrome b analysis |

`Individual_IDs.csv`

| Column     | Description                                       |
|------------|---------------------------------------------------|
| SampleID   | Unique identifier for DNA Sample                  |
| Individual | Label for individual coyote sample is assigned to |

`Family_Data.csv`

| Column | Description |
|-----------------|-------------------------------------------------------|
| Individual | Label for individual coyote sample is assigned to |
| Sex | Sex of individual |
| Breeder | Indicates whether or not individual is a breeder or non-breeder |

`func.RRA.clean.csv`

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

The scripts for the full workflow are available as R and Rmd files in the `Code` folder. All files are R scripts that were run in R version 4.2.1. The output of the models are not stored on github due to the large file sizes, but can be generated on your own device, or are available on Dryad Digital Repository (doi: XXXX).

-   `Clean_Data.Rmd`: this script takes the raw hormone data and cleans and formats the data for statistical analyses and data visualization.

-   `Correlations.R`: this script assesses the strength and significance of the correlation between each pair of hormones.

-   `GLMMs.Rmd`: the script uses the *brms* package to construct generalized linear mixed effect models that assess the effect of diet, impervious surface cover, and life history covariates on hormone metabolite concentrations. The script also constructs table of model output, calculates repeatabilities for random effects, computes average marginal contrasts and performs post-hoc tests for pairwise comparisons, and constructs plots to visualize model results.

-   `Study_Site_Map.R`: this script generates the study site sample collection map.

-   `ISA_Coyote_Scats.Rmd`: this script calculates the proportion of impervious surface cover in a buffer surrounding each scat collection location. Running this script requires downloading the associated impervious surface raster from <https://www.mrlc.gov/data>.

## Cleaned Data

In the `Cleaned_Data` folder, you will find a number of cleaned up files that are generated w ithin the R scripts described above.

Cleaned raw data:

-   `clean_hormone_genotypes_diet.csv`: output of `Clean_Data.Rmd` script

-   `scat_level_isa.csv`: output of `ISA_Coyote_Scats.Rmd` script

## Model Output

The output of the models are not stored on GitHub due to the large file sizes, but can be generated on your own device, or are available on Dryad Digital Repository (doi: XXXX).

-   `mod.GC.rds`, `mod.T3.rds`, `mod.T4.rds`, and `mod.interact.rds`: model output for the GLMMs

-   `mod.corr.GC.T3.rds`, `mod.corr.GC.T4.rds`, and `mod.corr.T4.T3.rds`: model output for the models assessing correlations between each pair of hormones

## Figures

In the `Figures` folder you will find all .png files for figures in the manuscript, which are generated by the scripts above.
