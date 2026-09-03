nextflow.enable.dsl=2

process FASTQC {

    tag "${sample}"

    input:
    tuple val(sample), path(reads)

    output:
    path "*_fastqc.html"
    path "*_fastqc.zip"

    script:
    """
    fastqc ${reads}
    """
}

workflow {

    reads_ch = Channel.fromFilePairs(
        'test/data/*_{R1,R2}.fastq.gz',
        checkIfExists: true
    )

    FASTQC(reads_ch)
}
