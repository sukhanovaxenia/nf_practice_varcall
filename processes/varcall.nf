process varcall {
    conda 'bioconda::bcftools'
    container 'staphb/bcftools:latest'
    publishDir 'results/varcall'
    tag "$sid"

    input:
    path reference
    tuple val(sid), path(bamFile), path(bamIndex)
    path faidx
    
    output:
    tuple val(sid), path("${sid}.vcf")

    script:
    """
    bcftools mpileup -Ou -f $reference $bamFile | bcftools call -mv > ${sid}.vcf
    """

}