nextflow.enable.dsl=2

process SHOW_PAIR {

    tag "${sample}"

    input:
    tuple val(sample), path(reads)

    script:
    """
    echo "Sample: ${sample}"
    echo "Reads: ${reads}"
    """
}

workflow {

    reads_ch = Channel.fromFilePairs(
        'test/data/*_{R1,R2}.fastq.gz',
        checkIfExists: true
    )

    reads_ch.view()

    SHOW_PAIR(reads_ch)
}
