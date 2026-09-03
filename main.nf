nextflow.enable.dsl=2

process SHOW_READ {

    input:
    path read

    script:
    """
    echo "Processing ${read}"
    """
}

workflow {

    reads_ch = Channel.fromPath('test/data/*.fastq.gz')
    
	reads_ch.view()

    SHOW_READ(reads_ch)
}
