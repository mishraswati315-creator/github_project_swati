# ============================================================
# Differential Expression Analysis using LIMMA
# Dataset: GSE268051
# ============================================================

# Install packages (run only once)
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(c("GEOquery","limma","pheatmap","EnhancedVolcano"))

library(GEOquery)
library(limma)
library(pheatmap)
library(EnhancedVolcano)

# -----------------------------
# 1. Load GEO dataset
# -----------------------------
gset <- getGEO("GSE268051", GSEMatrix = TRUE)
eset <- gset[[1]]

# -----------------------------
# 2. Expression matrix
# -----------------------------
expr <- exprs(eset)

# -----------------------------
# 3. Sample information
# -----------------------------
pheno <- pData(eset)

# IMPORTANT:
# Edit the group vector below to match your samples.
# Example for 6 samples (3 Control, 3 Disease):
group <- factor(c(
  "Control",
  "Control",
  "Control",
  "Disease",
  "Disease",
  "Disease"
))

# -----------------------------
# 4. Design matrix
# -----------------------------
design <- model.matrix(~0 + group)
colnames(design) <- levels(group)

# -----------------------------
# 5. LIMMA analysis
# -----------------------------
fit <- lmFit(expr, design)

contrast.matrix <- makeContrasts(
  Disease - Control,
  levels = design
)

fit2 <- contrasts.fit(fit, contrast.matrix)
fit2 <- eBayes(fit2)

# -----------------------------
# 6. Differentially expressed genes
# -----------------------------
results <- topTable(fit2, number = Inf)

write.csv(results,
          "DEG_results.csv",
          row.names = TRUE)

# -----------------------------
# 7. Significant DEGs
# -----------------------------
deg <- subset(results,
              adj.P.Val < 0.05 &
              abs(logFC) > 1)

write.csv(deg,
          "Significant_DEGs.csv",
          row.names = TRUE)

# -----------------------------
# 8. Volcano plot
# -----------------------------
pdf("Volcano_Plot.pdf", width = 8, height = 6)

EnhancedVolcano(
  results,
  lab = rownames(results),
  x = "logFC",
  y = "P.Value"
)

dev.off()

# -----------------------------
# 9. Heatmap
# -----------------------------
topGenes <- rownames(deg)

if(length(topGenes) > 1){
  pdf("Heatmap.pdf", width = 8, height = 8)
  pheatmap(expr[topGenes, ],
           scale = "row")
  dev.off()
}

# -----------------------------
# 10. Boxplot
# -----------------------------
pdf("Boxplot.pdf", width = 8, height = 6)

boxplot(expr,
        las = 2,
        col = "lightblue",
        main = "Expression Distribution")

dev.off()

# -----------------------------
# 11. Save workspace
# -----------------------------
save.image("GSE268051_analysis.RData")
savehistory("GSE268051_DE_analysis.Rhistory")

cat("Analysis completed successfully.\n")
