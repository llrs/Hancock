
# Setup data for this set of tests ----

ncells <- 100
u <- matrix(rpois(20000, 2), ncol=ncells)
rownames(u) <- paste0("Gene", sprintf("%03d", seq_len(nrow(u))))
colnames(u) <- paste0("Cell", sprintf("%03d", seq_len(ncol(u))))

se <- SummarizedExperiment(assays=list(counts=u))

# makeMarkerDetectionMatrix ----

test_that("makeMarkerDetectionMatrix works", {
    markers <- c("Gene001", "Gene002", "Gene003", "Gene004")
    out <- makeMarkerDetectionMatrix(se, markers, threshold=0, assay.type="counts")

    # Matrix orientation was preserved: rows are features (e.g. genes)
    expect_identical(nrow(out), length(markers))
    expect_identical(rownames(out), markers)
    # Matrix orientation was preserved: columns are samples (e.g. cells)
    expect_identical(ncol(out), ncol(se))
    expect_identical(colnames(out), colnames(se))

    expect_type(out, "logical")
})

test_that("makeMarkerDetectionMatrix warns about duplicated markers", {

    markers <- c("Gene001", "Gene001")
    expect_warning(
        makeMarkerDetectionMatrix(se, markers, threshold=0, assay.type="counts"),
        "Dropping duplicated markers values"
    )

})

# makeMarkerProportionMatrix ----

test_that("makeMarkerProportionMatrix works", {
    dummyCluster <- factor(sample(head(LETTERS, 3), ncol(se), replace=TRUE))
    colData(se)[, "cluster"] <- dummyCluster
    out <- makeMarkerProportionMatrix(se, "cluster")

    # One row per feature in the input object
    expect_identical(nrow(out), nrow(se))
    # One column per cluster
    expect_identical(ncol(out), nlevels(dummyCluster))
    # All values between 0 and 1
    expect_true(all(out >= 0))
    expect_true(all(out <= 1))
    expect_type(out, "double")
})

# makeMarkerProportionScree ----

test_that("makeMarkerProportionScree works", {
    markerDetectionMatrix <- makeMarkerDetectionMatrix(se, rownames(se), threshold=0, assay.type="counts")
    # Typical use case: Get the list of markers ordered by decreasing detection rate
    orderedMarkers <- rownames(markerDetectionMatrix)[order(rowSums(markerDetectionMatrix), decreasing=TRUE)]
    # Reorder the marker detection matrix
    markerDetectionMatrix <- markerDetectionMatrix[orderedMarkers, ]

    proportionScreen <- makeMarkerProportionScree(markerDetectionMatrix)

    # One value per input row
    expect_identical(length(proportionScreen), nrow(se))
    # Decreasing values
    expect_identical(proportionScreen, sort(proportionScreen, decreasing=TRUE))
})

# makeSignatureDetectionMatrix ----

test_that("makeSignatureDetectionMatrix works", {
    nmarkers <- 5
    markerMatrix <- matrix(sample(c(TRUE, FALSE), 100, TRUE), nrow=nmarkers, ncol=ncells)
    rownames(markerMatrix) <- paste0("Marker", sprintf("%02d", seq_len(nrow(markerMatrix))))
    gsc <- GeneSetCollection(
        GeneSet(c("Marker01", "Marker02"), setName="Set1"),
        GeneSet(c("Marker03", "Marker04"), setName="Set2")
    )

    out <- makeSignatureDetectionMatrix(markerMatrix, gsc)
    # Each signature is a column in the output matrix
    expect_identical(ncol(out), length(gsc))
    # The marker detection matrix was flipped: samples have become rows
    expect_identical(nrow(out), ncol(markerMatrix))
    expect_type(out, "logical")
})
