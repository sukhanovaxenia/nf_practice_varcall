process refindex {
    conda 'bioconda::bwa bioconda::samtools'
    container 'glebusasha/bwa_samtools'
    publishDir 'results/refindex'
    tag "$reference"

    input:
    path reference
    
    output:
    path "*"
    
    script:
    """
    bwa index $reference
    """

}