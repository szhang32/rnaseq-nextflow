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


process STAR_ALIGN {

    tag "${sample}"

    module 'STAR/2.7.9a'


    publishDir 'results/star', mode: 'copy'

    input:
    tuple val(sample), path(reads)
    path genome_index

    output:
    tuple val(sample),
          path("${sample}.Aligned.sortedByCoord.out.bam"),
          emit: bam

    path "${sample}.Log.final.out",
         emit: star_log

    script:
    """
    STAR \
        --genomeDir ${genome_index} \
        --readFilesIn ${reads[0]} ${reads[1]} \
        --readFilesCommand zcat \
        --runThreadN ${task.cpus} \
        --outSAMtype BAM SortedByCoordinate \
        --outFileNamePrefix ${sample}.
    """
}


workflow {

    reads_ch = Channel.fromFilePairs(
        'test/data/*_{R1,R2}.fastq.gz',
        checkIfExists: true
    )

    star_index_ch = Channel.fromPath(
        '/home/szhang32/ref/mm39/STAR_ncbi_mm39_refSeq',
        checkIfExists: true
    )

    /*
     * QC branch
     */
    fastqc_out = FASTQC(reads_ch)

    MULTIQC(
        fastqc_out.fastqc_zip.collect()
    )

    /*
     * Alignment branch
     */
    STAR_ALIGN(
        reads_ch,
        star_index_ch
    )
}
