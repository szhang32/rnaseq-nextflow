nextflow.enable.dsl=2

workflow {

    reads_ch = Channel.of(
        'sample1.fastq.gz',
        'sample2.fastq.gz',
        'sample3.fastq.gz'
    )

    reads_ch.view()
}
