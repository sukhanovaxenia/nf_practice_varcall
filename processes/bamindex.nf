process bamindex {
    conda 'bioconda::bwa bioconda::samtools'
    container 'glebusasha/bwa_samtools'
    publishDir 'results/bamindex'
    tag "$sid"

    input:
    tuple val(sid), path(bamFile)
    
    output:
    tuple val(sid), path("*.bai")

    script:
    """
    samtools index ${bamFile}
    """

}