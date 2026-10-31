process flagstat {
    conda 'bioconda::bwa bioconda::samtools'
    container 'glebusasha/bwa_samtools'
    publishDir 'results/flagstat'
    tag "$sid"

    input:
    tuple val(sid), path(bamFile)
    output:
    tuple val(sid), path("${sid}.flagstat")
    script:
    """
    samtools flagstat $bamFile > ${sid}.flagstat
    """

}