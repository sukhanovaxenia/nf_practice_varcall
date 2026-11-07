process bcfstats {
    conda 'bioconda::bcftools'
    container 'bcftools:arm64'
    containerOptions '--entrypoint ""'
    publishDir 'results/bcfstats'
    tag "$sid"

    input:
    tuple val(sid), path(vcf)
    output:
    tuple val(sid), path("${sid}.bcfstats")
    script:
    """
    bcftools stats $vcf > ${sid}.bcfstats
    """

}