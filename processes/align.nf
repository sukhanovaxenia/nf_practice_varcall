process align {
    conda 'bioconda::bwa bioconda::samtools'
    container 'glebusasha/bwa_samtools'
    publishDir 'results/align'
    tag "$sid"

    input:
    path reference
    tuple val(sid), path(reads1), path(reads2)
    path bwaindex

    output:
    tuple val(sid), path("${sid}.bam")

    script:
    """
    bwa mem \
        ${reference} ${reads1} ${reads2} | \
        samtools view -bh | \
        samtools sort -o ${sid}.bam
    """

}