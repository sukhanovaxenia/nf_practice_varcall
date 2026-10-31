process report {
    conda 'bioconda::multiqc'
    container 'staphb/multiqc:latest'
    publishDir 'results/report', mode: 'copy'

    input:
    path files
    output:
    path "*"
    script:
    """
    multiqc .
    """

}