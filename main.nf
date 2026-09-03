nextflow.enable.dsl=2

process SHOW_PAIR {

    tag "${sample}"

    input:
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("*.txt"), emit: report

    script:
    """
    echo "Sample: ${sample}" > ${sample}.txt
    echo "R1: ${reads[0]}" >> ${sample}.txt
    echo "R2: ${reads[1]}" >> ${sample}.txt
    """
}

process CHECK_REPORT {

    tag "${sample}"

    input:
    tuple val(sample), path(report)

    script:
    """
    echo "Checking ${report}"
    cat ${report}
    """
}

workflow {

    reads_ch = Channel.fromFilePairs(
        'test/data/*_{R1,R2}.fastq.gz',
        checkIfExists: true
    )

    result_ch = SHOW_PAIR(reads_ch)

    CHECK_REPORT(result_ch.report)
}

