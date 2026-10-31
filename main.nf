#!/usr/bin/env nextflow

include { refindex } from './processes/refindex.nf'
include { qcontrol } from './processes/qcontrol.nf'
include { align    } from './processes/align.nf'
include { faindex  } from './processes/faindex.nf'
include { bamindex } from './processes/bamindex.nf'
include { varcall  } from './processes/varcall.nf'
include { flagstat } from './processes/flagstat.nf'
include { bcfstats } from './processes/bcfstats.nf'
include { report   } from './processes/report.nf'


workflow refprepare {
    take:
    reference

    main:
    refindex(reference)
    faindex(reference)

    emit:
    bwaindex = refindex.out
}


workflow align_varcall {
    take:
    reference
    bwaindex
    reads

    main:
    qcontrol(reads)

    align(
        reference,
        qcontrol.out[0],
        bwaindex
    )

    bamindex(align.out)

    varcall(
        reference,
        align.out.join(bamindex.out),
        bwaindex
    )

    flagstat(align.out)
    bcfstats(varcall.out)

    report(
        qcontrol.out.json
            .mix(flagstat.out.map { it -> it[1] })
            .mix(bcfstats.out.map { it -> it[1] })
            .collect()
    )

    emit:
    varcall = varcall.out
    report  = report.out
}


workflow {
    main:
    reads = channel.fromFilePairs(params.reads)
    reference = channel.fromPath(params.reference).collect()

    refprepare(reference)

    align_varcall(
        reference,
        refprepare.out.bwaindex,
        reads
    )

    publish:
    report = align_varcall.out.report
}


output {
    report {
        path 'report'
        mode 'copy'
    }
}
