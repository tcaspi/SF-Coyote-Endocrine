# SF-Coyote-Endocrine

This repository contains all raw data, plots and scripts for the data analysis implemented in Caspi et al. (XXXX) (In Preparation) titled: Urbanization and diet shape the endocrine physiology of coyotes (Canis latrans) and published in XXXXX.

Please find below a description of all raw and clean data sets and the scripts used to clean the raw data, run the models, and create the figures presented in the manuscript.

## Data files

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

| Column    | Description                                                        |
|-----------------|-------------------------------------------------------|
| SampleID  | Unique identifier for DNA sample                                   |
| Replicate | Indicates whether the sample was a replicate extraction or not     |
| FieldID   | Unique identifier for the sample when collected in the field       |
| Site      | Site code for location sample was collected                        |
| Area      | Indicates whether sample was collected in urban or nonurban region |
| Initials  | Initials of person who collected the sample in the field           |
| Year      | Year sample was collected                                          |
| Month     | Month sample was collected                                         |
| Day       | Day sample was collected                                           |
| Condition | Condition of sample at time of collection                          |
| Lat       | Latitude                                                           |
| Long      | Longitude                                                          |
| Geno.Sp   | Species identification from genotyping                             |
| Cytb_Sp   | Species identification from Cytochrome b analysis                  |

`Individual_IDs.csv`

| Column     | Description                                       |
|------------|---------------------------------------------------|
| SampleID   | Unique identifier for DNA Sample                  |
| Individual | Label for individual coyote sample is assigned to |

`Family_Data.csv`

| Column     | Description                                                     |
|-----------------|-------------------------------------------------------|
| Individual | Label for individual coyote sample is assigned to               |
| Sex        | Sex of individual                                               |
| Breeder    | Indicates whether or not individual is a breeder or non-breeder |

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

`Territory_Covariates.csv`

| Column           | Description                                                                            |
|------------------|----------------------------------------------------------------------------------------|
| Territory        | Name of coyote territory                                                               |
| lat              | Latitude of territory center point                                                     |
| long             | Longitude of territory center point                                                    |
| ISA              | Percent impervious surface cover in 1km buffer surrounding territory center point      |
| Urban            | Percent of land classified as urban in 1km buffer surrounding territory center point   |
| Food.Services    | Number of restaurants in 1km buffer surrounding territory center point                 |
| Pop.Den.2020     | Mean human population density in 2020 in 1km buffer surrounding territory center point |
| Housing.Den.2020 | Mean housing density in 2020 in 1km buffer surrounding territory center point          |

## Scripts

The scripts for the full workflow are available as R and Rmd files in the `Code` folder. All files are R scripts that were run in R version 4.2.1. The output of the models are not stored on github due to the large file sizes, but can be generated on your own device, or are available on Dryad Digital Repository (doi: XXXX).

-   `Clean_Data.Rmd`: this script takes the raw hormone data and cleans and formats the data for statistical analyses and data visualization.

-   `Plot_Samples_Over_Time.R`: this script makes supplementary figures 2-4 showing hormone concentrations in fecal samples per individual over time.

-   `Correlations.R`: this script assesses the strength and significance of the correlation between each pair of hormones.

-   `Mixed_Effect_Models.Rmd`: the script uses the brms package to construct double-hierarchical generalized linear models and generalized linear mixed effect models that assess the effect of diet, impervious surface cover, and life history covariates on among-individual differences in hormonal means (and variances for the DHGLM models). The script also assess the effect of sample size on predicted rIIV values.

-   `Study_Site_Map.R`: this script generates the study site sample collection map.

## Clean data

In the `Cleaned_Data` folder, you will find a number of cleaned up files that are generated w ithin the R scripts described above.

Cleaned raw data:

> -   `cleaned_hormone_all_diet.csv`: output of `Clean_Data.Rmd` script
>
> -   `clean_hormone_genotypes_diet.csv`: output of `Clean_Data.Rmd` script

## Model output

The output of the models are not stored on GitHub due to the large file sizes, but can be generated on your own device, or are available on Dryad Digital Repository (doi: XXXX).

| `dhglm_GC.rds`, `dhglm_T3.rds`, and `dhglm_T4.rds`: model output for the double hierarchical generalized linear models

| `glmm_GC.rds`, `glmm_T3.rds`, and `glmm_T4.rds`: model output for the generalized linear mixed effect models

## Figures

In the `Figures` folder you will find all .png files for figures in the manuscript, which are generated by the scripts above.
