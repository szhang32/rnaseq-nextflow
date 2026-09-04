nextflow.enable.dsl=2

process FASTQC {

    tag "${sample}"

    conda '/home/szhang32/.conda/envs/nf-fastqc'

    publishDir 'results/fastqc', mode: 'copy'

    input:
    tuple val(sample), path(reads)

    output:
    path "*_fastqc.zip", emit: fastqc_zip
    path "*_fastqc.html"

    script:
    """
    fastqc ${reads}
    """
}


process MULTIQC {

    conda '/home/szhang32/.conda/envs/multiqc'

    publishDir 'results/multiqc', mode: 'copy'

    input:
    path fastqc_files

    output:
    path "multiqc_report.html"
    path "multiqc_data"

    script:
    """
    multiqc .
    """
}


workflow {

    reads_ch = Channel.fromFilePairs(
        'test/data/*_{R1,R2}.fastq.gz',
        checkIfExists: true
    )

    fastqc_out = FASTQC(reads_ch)

    MULTIQC(
        fastqc_out.fastqc_zip.collect()
    )
}
