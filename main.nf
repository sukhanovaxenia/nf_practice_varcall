#!/usr/bin/env nextflow
include { refindex} from './processes/refindex.nf'
include { qcontrol } from './processes/qcontrol.nf'
include { align } from './processes/align.nf'
include { bamindex} from './processes/bamindex.nf'
include { flagstat } from './processes/flagstat.nf'
include { faindex } from './processes/faindex.nf'
include { varcall } from './processes/varcall.nf'
include { bcfstats } from './processes/bcfstats.nf'
include { report } from './processes/report.nf'

// params.reads        = 'data/*_R{1,2}.fastq.gz'
// params.reference    = 'data/MT.fna'

// process refidx{
//     conda 'bioconda::bwa'

//     tag "$reference"

//     publishDir 'ref', mode: 'link'

//     input:
//     path reference // path as files

//     output:
//     path "*" // return all files

//     script:
//     """
//     bwa index ${reference} # {} not obligatory, it's nextflow variable
//     # for bash variables \$ with backslash
//     """
// }

// process qc{
//     tag "$sid"

//     conda 'bioconda::fastp' // prepared env also can be defined

//     memory '2 GB' // limit memory consumption

//     publishDir 'results/qc', mode: 'copy'
    
//     input:
//     tuple val(sid), path(reads) // for tuples () are obligatory
//     // sid is useful for naming output files

//     output:
//     path "*"

//     script:
//     """
//     fastp \
//         --in1 ${reads[0]} \
//         --in2 ${reads[1]} \
//         --out1 "${sid}_trimmed_R1.fq" \
//         --out2 "${sid}_trimmed_R2.fq" \
//         --html ${sid}.fastp_stats.html \
//         --json ${sid}.fastp_stats.json   
//     """
// }

workflow {
    reads = channel.fromFilePairs(params.reads)
    // reads.view()
    reference = channel.fromPath(params.reference).collect()
    refindex(reference)
    qcontrol(reads)
    // qcontrol.out[0].view()
    align(reference, qcontrol.out[0], refindex.out)
    faindex(reference)
    bamindex(align.out)
    vc_input = align.out.join(bamindex.out) // join tuples by 1st element (not necessry the 1st)
    // previous deplicated merge operator
    varcall(reference, vc_input, faindex.out)
    flagstat(align.out)
    bcfstats(varcall.out)
    report_in = qcontrol.out.json
        .mix(flagstat.out.map {it -> it[1] }.view())
        .mix(bcfstats.out.map {it -> it[1] }.view())
    report(report_in.collect())
}