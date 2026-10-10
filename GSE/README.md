# Differential Expression Analysis Using LIMMA

This repository contains an R script for differential gene-expression analysis using the GEO dataset **GSE268051**. The workflow retrieves the GEO expression matrix, compares two sample groups using **LIMMA**, exports differential-expression tables, and creates visualizations.

## Project overview

- **Dataset:** [GSE268051 on NCBI GEO](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE268051)
- **Language:** R
- **Main method:** LIMMA (Linear Models for Microarray Data)
- **Visualizations:** Volcano plot, heatmap, and expression-distribution boxplot

> **Important:** The supplied script uses an example group vector containing 3 `Control` and 3 `Disease` labels. Before running the analysis, verify the dataset's actual sample order and group labels, then update `group` to match the samples in the expression matrix. Do not assume the example labels are correct for this dataset.

## Workflow

1. Load the required R/Bioconductor packages.
2. Download the GEO Series Matrix for `GSE268051` with `GEOquery`.
3. Extract the expression matrix and sample phenotype metadata.
4. Define the sample groups (`Control` and `Disease` in the example script).
5. Build a design matrix.
6. Fit linear models with `limma`.
7. Set the contrast to `Disease - Control` and apply empirical Bayes moderation.
8. Export the complete differential-expression results.
9. Filter significant genes using adjusted p-value < 0.05 and absolute log fold change > 1.
10. Generate a volcano plot, a heatmap of selected significant genes (when more than one gene passes the filter), and a boxplot.
11. Save the R workspace and command history.

## Requirements

Install R and, if needed, install the required packages once:

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

BiocManager::install(c("GEOquery", "limma"))
install.packages(c("pheatmap", "EnhancedVolcano"))
```

The script loads these packages:

- `GEOquery` — retrieves the GEO dataset
- `limma` — fits linear models and tests the contrast
- `pheatmap` — draws the heatmap
- `EnhancedVolcano` — draws the volcano plot

## How to run

1. Download or clone this repository.
2. Open the `.R` script in RStudio or another R environment.
3. Check the sample metadata and confirm the sample order in `pData(eset)`.
4. Edit the `group` vector so it has exactly one label per column in `expr`, in the same order as the samples.
5. Confirm that the labels `Control` and `Disease` match the intended comparison.
6. Run the script from top to bottom.

Example check to run after loading the dataset:

```r
dim(expr)
head(pheno)
colnames(expr)
```

The group vector in the supplied script is only an example; the analysis may be invalid if its labels or order do not match the GEO sample metadata.

## Output files

When the script completes successfully, it is designed to create these files in the current working directory:

| File | Description |
|---|---|
| `DEG_results.csv` | Full LIMMA results for all tested features |
| `Significant_DEGs.csv` | Features passing `adj.P.Val < 0.05` and `abs(logFC) > 1` |
| `Volcano_Plot.pdf` | Volcano plot using log fold change and raw p-value |
| `Heatmap.pdf` | Row-scaled heatmap of significant features, if more than one passes the filter |
| `Boxplot.pdf` | Expression-distribution boxplot |
| `GSE268051_analysis.RData` | Saved R workspace |
| `GSE268051_DE_analysis.Rhistory` | Saved R command history |

## Significance criteria

The supplied script defines significant differentially expressed genes/features as:

- Adjusted p-value (`adj.P.Val`) < 0.05
- Absolute log fold change (`abs(logFC)`) > 1

The contrast is `Disease - Control`. Positive log fold change indicates higher expression in the `Disease` group relative to `Control`; negative log fold change indicates lower expression, provided the group labels and contrast are correctly specified.

## Notes and limitations

- Confirm whether the GEO platform contains gene-level measurements or other feature identifiers before interpreting the results as genes.
- The script retrieves `pheno` but does not automatically derive the group labels from it. Manual verification is required.
- The volcano plot currently uses `P.Value` (raw p-value) for its y-axis, while the significance filter uses `adj.P.Val`.
- The heatmap uses all rows that pass the significance filter; if zero or one feature passes, the script skips creating `Heatmap.pdf`.
- Results depend on the correct sample grouping, platform annotation, and suitability of the downloaded expression data for the selected LIMMA workflow.

## Suggested repository structure

```text
limma-differential-expression/
├── README.md
├── GSE268051_DE_analysis.R
└── results/
    ├── DEG_results.csv
    ├── Significant_DEGs.csv
    ├── Volcano_Plot.pdf
    ├── Heatmap.pdf
    └── Boxplot.pdf
```

The `results/` directory above is a suggested organization. The current script writes output files to R's current working directory unless you change the output paths.

## Citation

Please cite the GSE268051 dataset and the LIMMA/Bioconductor tools according to their official documentation when publishing or presenting results.

- GEO dataset: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE268051
- LIMMA: https://bioconductor.org/packages/limma/
- GEOquery: https://bioconductor.org/packages/GEOquery/

## License

No license is specified in the supplied script. Add a license file if you want others to reuse or redistribute this repository.
