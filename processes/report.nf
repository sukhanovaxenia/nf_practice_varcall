process report {
    conda 'bioconda::multiqc'
    container 'multiqc:arm64'
    containerOptions '--entrypoint ""'
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